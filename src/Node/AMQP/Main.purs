module Node.AMQP.Main where

import Node.AMQP
import Prelude

import Control.Monad.Aff (delay, runAff)
import Control.Monad.Eff (Eff, kind Effect)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE, log, logShow)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Maybe (Maybe(..))
import Data.StrMap as StrMap
import Data.Time.Duration (Milliseconds(..))
import Node.Buffer (BUFFER, fromString, toString)
import Node.Encoding (Encoding(..))
import Node.Process (PROCESS)

main :: forall eff. Eff ( console   :: CONSOLE
                        , amqp      :: AMQP
                        , exception :: EXCEPTION
                        , process   :: PROCESS
                        , buffer    :: BUFFER
                        | eff ) Unit
main = do
  log "Starting"
  content <- fromString "test123" UTF8
  void $ runAff (\e -> log "ERRORAFF" *> logShow e) pure do
    conn <- connect "amqp://localhost" defaultConnectOptions
    liftEff $ log "Connected"
    let q = "queue111"
        x = "exc2222"

    liftEff $ do
      onConnectionClose conn $ case _ of
        Just err -> log $ "E: Conn closed: " <> show err
        Nothing  -> log "E: Conn closed"
      onConnectionError conn \err -> log $ "E: Conn errored: " <> show err
      onConnectionBlocked conn \reason -> log $ "E: Conn blocked: " <> reason
      onConnectionUnblocked conn (log "E: Conn unblocked")

    withChannel conn \channel -> do
      liftEff $ log "Channel created"
      prefetch channel 10

      liftEff $ do
        onChannelClose channel (log "E: Channel close")
        onChannelError channel \err -> log $ "E: Channel errored: " <> show err
        onChannelReturn channel \msg ->
          toString UTF8 msg.content >>= \m -> log $ "E: Channel message returned: " <> m
        onChannelDrain channel (log "E: Channel drained")

      ok <- assertQueue channel q defaultQueueOptions
      liftEff $ log $ "Queue created: " <> ok.queue

      consumeChannel <- createChannel conn
      liftEff $ onChannelClose consumeChannel (log "E: Consume Channel close")

      recover consumeChannel

      ok <- consume consumeChannel q defaultConsumeOptions $ case _ of
        Nothing -> do
          log "Consumer closed"
          void $ runAff logShow logShow $ closeChannel consumeChannel
        Just msg -> do
          toString UTF8 msg.content >>= \m -> log $ "Received: " <> m
          ack consumeChannel msg.fields.deliveryTag
          logShow msg.properties.persistent

      let consumerTag = ok.consumerTag
      liftEff $ log $ "Consumer tag: " <> ok.consumerTag

      ok <- purgeQueue channel q
      liftEff $ log $ "Queue purged: " <> show ok.messageCount

      assertExchange channel x Fanout defaultExchangeOptions
      liftEff $ log $ "Exchange created"

      bindQueue channel q x "*" StrMap.empty
      liftEff $ log $ "Queue bound"

      publish channel x "" content $ defaultPublishOptions { persistent = Just false }
      liftEff $ log $ "Message published to exchange"

      delay (Milliseconds 500.0)

      liftEff $ ackAll consumeChannel
      cancel consumeChannel consumerTag
      closeChannel consumeChannel

      sendToQueue channel q content $ defaultPublishOptions { persistent = Just true }
      liftEff $ log $ "Message published to queue"

      delay (Milliseconds 500.0)

      get channel q defaultGetOptions >>= case _ of
        Nothing -> liftEff $ log "No message received"
        Just msg -> liftEff do
          toString UTF8 msg.content >>= \m -> log $ "Get Received: " <> m
          nackAllUpTo channel msg.fields.deliveryTag true

      unbindQueue channel q x "*" StrMap.empty
      liftEff $ log $ "Queue unbound"

      deleteExchange channel x defaultDeleteExchangeOptions
      liftEff $ log $ "Exchange deleted"

      ok <- deleteQueue channel q defaultDeleteQueueOptions
      liftEff $ log $ "Queue deleted: " <> show ok.messageCount

    close conn
    liftEff $ log $ "Connection closed"
