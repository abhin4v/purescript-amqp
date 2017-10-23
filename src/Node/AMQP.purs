module Node.AMQP
  ( module MoreExports
  , module Node.AMQP.Types
  , module Node.AMQP
  ) where

import Node.AMQP.FFI
import Node.AMQP.Types
import Node.AMQP.Types.Internal
import Prelude

import Control.Monad.Aff (makeAff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Exception (Error, message)
import Control.Monad.Error.Class (withResource)
import Data.Foreign (Foreign)
import Data.Foreign.Class (encode)
import Data.Function.Uncurried (runFn1, runFn2, runFn3, runFn4, runFn5, runFn6, runFn7)
import Data.Maybe (Maybe)
import Data.Nullable (toMaybe)
import Data.StrMap (StrMap)
import Data.String (Pattern(..), contains)
import Node.AMQP.FFI (EffAMQP, AffAMQP) as MoreExports
import Node.Buffer (Buffer)

-- | Connects to an AMQP server given an AMQP URL and [connection options]. Returns the connection in
-- | `Aff` monad. See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#connect) for details.
connect :: forall eff. String -> ConnectOptions -> AffAMQP eff Connection
connect url = makeAff <<< runFn3 _connect <<< connectUrl url

-- | Closes the given AMQP connection.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#model_close) for details.
close :: forall eff. Connection -> AffAMQP eff Unit
close conn = makeAff $ \onError onSuccess -> flip (runFn3 _close conn) onSuccess \err -> do
  if contains (Pattern "Connection closed") (message err)
    then onSuccess unit
    else onError err

-- | Creates an open channel and returns it.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#model_createChannel) for details.
createChannel :: forall eff. Connection -> AffAMQP eff Channel
createChannel = makeAff <<< runFn3 _createChannel

-- | Closes the given channel.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_close) for details.
closeChannel :: forall eff. Channel -> AffAMQP eff Unit
closeChannel = makeAff <<< runFn3 _closeChannel

-- | Asserts a queue into existence with the given name and options.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_assertQueue) for details.
assertQueue :: forall eff. Channel -> QueueName -> QueueOptions -> AffAMQP eff AssertQueueOK
assertQueue channel queue =
  makeAff <<< runFn5 _assertQueue channel queue <<< encodeQueueOptions

-- | Checks that a queue exists with the given queue name.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_checkQueue) for details.
checkQueue :: forall eff. Channel -> QueueName -> AffAMQP eff AssertQueueOK
checkQueue channel = makeAff <<< runFn4 _checkQueue channel

-- | Deletes the queue by the given name.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_deleteQueue) for details.
deleteQueue :: forall eff. Channel -> QueueName -> DeleteQueueOptions -> AffAMQP eff DeleteQueueOK
deleteQueue channel queue =
  makeAff <<< runFn5 _deleteQueue channel queue <<< encodeDeleteQueueOptions

-- | Purges the messages from the queue by the given name.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_purgeQueue) for details.
purgeQueue :: forall eff. Channel -> QueueName -> AffAMQP eff PurgeQueueOK
purgeQueue channel = makeAff <<< runFn4 _purgeQueue channel

-- | Asserts a routing path from an exchange to a queue: the given exchange will relay
-- | messages to the given queue, according to the type of the exchange and the given routing key.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_bindQueue) details.
bindQueue :: forall eff. Channel -> QueueName -> ExchangeName -> RoutingKey -> StrMap Foreign -> AffAMQP eff Unit
bindQueue channel queue exchange routingKey =
  makeAff <<< runFn7 _bindQueue channel queue exchange routingKey <<< encode

-- | Removes the routing path between the given queue and the given exchange with the given routing key and arguments.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_unbindQueue) for details.
unbindQueue :: forall eff. Channel -> QueueName -> ExchangeName -> RoutingKey -> StrMap Foreign -> AffAMQP eff Unit
unbindQueue channel queue exchange routingKey =
  makeAff <<< runFn7 _unbindQueue channel queue exchange routingKey <<< encode

-- | Asserts an exchange into existence with the given exchange name, type and options.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_assertExchange) for details.
assertExchange :: forall eff. Channel -> ExchangeName -> ExchangeType -> ExchangeOptions -> AffAMQP eff Unit
assertExchange channel exchange exchangeType =
  makeAff <<< runFn6 _assertExchange channel exchange (show exchangeType) <<< encodeExchangeOptions

-- | Checks that the exchange exists by the given name.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_checkExchange) for details.
checkExchange :: forall eff. Channel -> ExchangeName -> AffAMQP eff Unit
checkExchange channel = makeAff <<< runFn4 _checkExchange channel

-- | Deletes the exchange by the given name.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_deleteExchange) for details.
deleteExchange :: forall eff. Channel -> ExchangeName -> DeleteExchangeOptions -> AffAMQP eff Unit
deleteExchange channel exchange =
  makeAff <<< runFn5 _deleteExchange channel exchange <<< encodeDeleteExchangeOptions

-- | Binds an exchange to another exchange. The exchange named by `destExchange` will receive messages
-- | from the exchange named by `sourceExchange`, according to the type of the source and the given
-- | routing key.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_bindExchange) for details.
bindExchange :: forall eff. Channel -> ExchangeName -> ExchangeName -> RoutingKey -> StrMap Foreign -> AffAMQP eff Unit
bindExchange channel destExchange sourceExchange routingKey =
  makeAff <<< runFn7 _bindExchange channel destExchange sourceExchange routingKey <<< encode

-- | Removes a binding from an exchange to another exchange.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_unbindExchange) for details.
unbindExchange :: forall eff. Channel -> ExchangeName -> ExchangeName -> RoutingKey -> StrMap Foreign -> AffAMQP eff Unit
unbindExchange channel destExchange sourceExchange routingKey =
  makeAff <<< runFn7 _unbindExchange channel destExchange sourceExchange routingKey <<< encode

-- | Publish a single message to the given exchange with the given routing key, and the given publish
-- | options. The message content is given as a `Buffer`.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_publish) for details.
publish :: forall eff. Channel -> ExchangeName -> RoutingKey -> Buffer -> PublishOptions -> AffAMQP eff Unit
publish channel exchange routingKey buffer =
  makeAff <<< const <<< runFn6 _publish channel exchange routingKey buffer <<< encodePublishOptions

-- | Sends a single message with the content given as a `Buffer` to the given queue, bypassing routing.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_sendToQueue) for details.
sendToQueue :: forall eff. Channel -> QueueName -> Buffer -> PublishOptions -> AffAMQP eff Unit
sendToQueue channel queue buffer =
  makeAff <<< const <<< runFn5 _sendToQueue channel queue buffer <<< encodePublishOptions

-- | Sets up a consumer for the given queue and consume options, with a callback to be invoked with each message.
-- | The callback receives `Nothing` if the consumer is cancelled by the broker. Returns the consumer tag.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_consume) for details.
consume :: forall eff. Channel -> QueueName -> ConsumeOptions -> (Maybe Message -> EffAMQP eff Unit) -> AffAMQP eff ConsumeOK
consume channel queue options onMessage =
  makeAff $ runFn6 _consume channel queue (toMaybe >>> map toMessage >>> onMessage) (encodeConsumeOptions options)

-- | Cancels the consumer identified by the given consumer tag.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_cancel) for details.
cancel :: forall eff. Channel -> String -> AffAMQP eff Unit
cancel channel = makeAff <<< runFn4 _cancel channel

-- | Gets a message from the given queue. If there are no messages in the queue, returns `Nothing`.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_get) for details.
get :: forall eff. Channel -> QueueName -> GetOptions -> AffAMQP eff (Maybe Message)
get channel queue opts = makeAff \onError onSuccess ->
  runFn5 _get channel queue (encodeGetOptions opts) onError (onSuccess <<< map toMessage <<< toMaybe)

-- | Acknowledges a message given its delivery tag.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_ack) for details.
ack :: forall eff. Channel -> String -> EffAMQP eff Unit
ack channel deliveryTag = runFn3 _ack channel deliveryTag false

-- | Acknowledges all messages up to the message with the given delivery tag.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_ack) for details.
ackAllUpTo :: forall eff. Channel -> String -> EffAMQP eff Unit
ackAllUpTo channel deliveryTag = runFn3 _ack channel deliveryTag true

-- | Acknowledges all outstanding messages on the channel.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_ackAll) for details.
ackAll :: forall eff. Channel -> EffAMQP eff Unit
ackAll = runFn1 _ackAll

-- | Rejects a message given its delivery tag. If the boolean param is true, the server requeues the
-- | message, else it drops it.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_nack) for details.
nack :: forall eff. Channel -> String -> Boolean -> EffAMQP eff Unit
nack channel deliveryTag = runFn4 _nack channel deliveryTag false

-- | Rejects all messages up to the message with the given delivery tag. If the boolean param is true,
-- | the server requeues the messages, else it drops them.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_nack) for details.
nackAllUpTo :: forall eff. Channel -> String -> Boolean -> EffAMQP eff Unit
nackAllUpTo channel deliveryTag = runFn4 _nack channel deliveryTag true

-- | Rejects all outstanding messages on the channel. If the boolean param is true,
-- | the server requeues the messages, else it drops them.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_nackAll) for details.
nackAll :: forall eff. Channel -> Boolean -> EffAMQP eff Unit
nackAll = runFn2 _nackAll

-- | Sets the prefetch count for this channel.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_prefetch) for details.
prefetch :: forall eff. Channel -> Int -> AffAMQP eff Unit
prefetch channel = liftEff <<< runFn2 _prefetch channel

-- | Requeues unacknowledged messages on this channel.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_recover) for details.
recover :: forall eff. Channel -> AffAMQP eff Unit
recover = makeAff <<< runFn3 _recover

-- | Registers an event handler to the connection which is triggered when the connection closes.
-- | If the connection closes because of an error, the handler is called with `Just error`, else
-- | with `Nothing`.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#model_events) for details.
onConnectionClose :: forall eff. Connection -> (Maybe Error -> EffAMQP eff Unit) -> EffAMQP eff Unit
onConnectionClose conn onClose = runFn2 _onConnectionClose conn (onClose <<< toMaybe)

-- | Registers an event handler to the connection which is triggered when the connection errors out.
-- | The handler is called with the error.
onConnectionError :: forall eff. Connection -> (Error -> EffAMQP eff Unit) -> EffAMQP eff Unit
onConnectionError = runFn2 _onConnectionError

-- | Registers an event handler to the connection which is triggered when the RabbitMQ server
-- | decides to block the connection. The handler is called with the reason for blocking.
onConnectionBlocked :: forall eff. Connection -> (String -> EffAMQP eff Unit) -> EffAMQP eff Unit
onConnectionBlocked = runFn2 _onConnectionBlocked

-- | Registers an event handler to the connection which is triggered when the RabbitMQ server
-- | decides to unblock the connection. The handler is called with no arguments.
onConnectionUnblocked :: forall eff. Connection -> EffAMQP eff Unit -> EffAMQP eff Unit
onConnectionUnblocked = runFn2 _onConnectionUnblocked

-- | Registers an event handler to the channel which is triggered when the channel closes.
-- | The handler is called with no arguments.
-- | See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_events) for details.
onChannelClose :: forall eff. Channel -> EffAMQP eff Unit -> EffAMQP eff Unit
onChannelClose = runFn2 _onChannelClose

-- | Registers an event handler to the channel which is triggered when the channel errors out.
-- | The handler is called with the error.
onChannelError :: forall eff. Channel -> (Error -> EffAMQP eff Unit) -> EffAMQP eff Unit
onChannelError = runFn2 _onChannelError

-- | Registers an event handler to the channel which is triggered when a message published with
-- | the mandatory flag cannot be routed and is returned to the sending channel. The handler is
-- | called with the returned message.
onChannelReturn :: forall eff. Channel -> (Message -> EffAMQP eff Unit) -> EffAMQP eff Unit
onChannelReturn channel onReturn = runFn2 _onChannelReturn channel (toMessage >>> onReturn)

-- | Registers an event handler to the channel which is triggered when the channel's write buffer
-- | is emptied. The handler is called with no arguments.
onChannelDrain :: forall eff. Channel -> EffAMQP eff Unit -> EffAMQP eff Unit
onChannelDrain = runFn2 _onChannelDrain

-- | A convenience function for creating a channel, doing some action with it, and then automatically closing
-- | it, even in case of errors.
withChannel :: forall eff a. Connection -> (Channel -> AffAMQP eff a) -> AffAMQP eff a
withChannel conn = withResource (createChannel conn) closeChannel
