module Node.AMQP.Main where

import Node.AMQP
import Prelude (Unit, bind, discard, pure, show, void, ($), (*>), (<>), (>>=))

import Effect.Aff (delay, runAff)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log, logShow)

import Data.Either (either)
import Data.Maybe (Maybe(..))
import Data.Time.Duration (Milliseconds(..))
import Foreign.Object (empty)
import Node.Buffer (fromString, toString)
import Node.Encoding (Encoding(..))


main :: Effect Unit
main = do
  log "Starting"
  content <- fromString "test123" UTF8
  void $ runAff (either (\e -> log "ERRORAFF" *> logShow e) pure) do
    conn <- connect "amqp://localhost" defaultConnectOptions
    liftEffect $ log "Connected"
    let q = "queue111"
        x = "exc2222"

    liftEffect $ do
      onConnectionClose conn $ case _ of
        Just err -> log $ "E: Conn closed: " <> show err
        Nothing  -> log "E: Conn closed"
      onConnectionError conn \err -> log $ "E: Conn errored: " <> show err
      onConnectionBlocked conn \reason -> log $ "E: Conn blocked: " <> reason
      onConnectionUnblocked conn (log "E: Conn unblocked")

    withChannel conn \channel -> do
      liftEffect $ log "Channel created"
      prefetch channel 10

      liftEffect $ do
        onChannelClose channel (log "E: Channel close")
        onChannelError channel \err -> log $ "E: Channel errored: " <> show err
        onChannelReturn channel \msg ->
          toString UTF8 msg.content >>= \m -> log $ "E: Channel message returned: " <> m
        onChannelDrain channel (log "E: Channel drained")

      ok <- assertQueue channel q defaultQueueOptions
      liftEffect $ log $ "Queue created: " <> ok.queue

      consumeChannel <- createChannel conn
      liftEffect $ onChannelClose consumeChannel (log "E: Consume Channel close")

      recover consumeChannel

      ok <- consume consumeChannel q defaultConsumeOptions $ case _ of
        Nothing -> do
          log "Consumer closed"
          void $ runAff (either logShow logShow) $ closeChannel consumeChannel
        Just msg -> do
          toString UTF8 msg.content >>= \m -> log $ "Received: " <> m
          ack consumeChannel msg.fields.deliveryTag
          logShow msg.properties.persistent

      let consumerTag = ok.consumerTag
      liftEffect $ log $ "Consumer tag: " <> ok.consumerTag

      ok <- purgeQueue channel q
      liftEffect $ log $ "Queue purged: " <> show ok.messageCount

      assertExchange channel x Fanout defaultExchangeOptions
      liftEffect $ log $ "Exchange created"

      bindQueue channel q x "*" empty
      liftEffect $ log $ "Queue bound"

      publish channel x "" content $ defaultPublishOptions { persistent = Just false }
      liftEffect $ log $ "Message published to exchange"

      delay (Milliseconds 500.0)

      liftEffect $ ackAll consumeChannel
      cancel consumeChannel consumerTag
      closeChannel consumeChannel

      sendToQueue channel q content $ defaultPublishOptions { persistent = Just true }
      liftEffect $ log $ "Message published to queue"

      delay (Milliseconds 500.0)

      get channel q defaultGetOptions >>= case _ of
        Nothing -> liftEffect $ log "No message received"
        Just msg -> liftEffect do
          toString UTF8 msg.content >>= \m -> log $ "Get Received: " <> m
          nackAllUpTo channel msg.fields.deliveryTag true

      unbindQueue channel q x "*" empty
      liftEffect $ log $ "Queue unbound"

      deleteExchange channel x defaultDeleteExchangeOptions
      liftEffect $ log $ "Exchange deleted"

      ok <- deleteQueue channel q defaultDeleteQueueOptions
      liftEffect $ log $ "Queue deleted: " <> show ok.messageCount

    close conn
    liftEffect $ log $ "Connection closed"
