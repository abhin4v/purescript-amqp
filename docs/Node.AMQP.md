## Module Node.AMQP

#### `connect`

``` purescript
connect :: forall eff. String -> ConnectOptions -> AffAMQP eff Connection
```

Connects to an AMQP server given an AMQP URL and [connection options]. Returns the connection in
`Aff` monad. See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#connect) for details.

#### `close`

``` purescript
close :: forall eff. Connection -> AffAMQP eff Unit
```

Closes the given AMQP connection.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#model_close) for details.

#### `createChannel`

``` purescript
createChannel :: forall eff. Connection -> AffAMQP eff Channel
```

Creates an open channel and returns it.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#model_createChannel) for details.

#### `closeChannel`

``` purescript
closeChannel :: forall eff. Channel -> AffAMQP eff Unit
```

Closes the given channel.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_close) for details.

#### `assertQueue`

``` purescript
assertQueue :: forall eff. Channel -> QueueName -> QueueOptions -> AffAMQP eff AssertQueueOK
```

Asserts a queue into existence with the given name and options.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_assertQueue) for details.

#### `checkQueue`

``` purescript
checkQueue :: forall eff. Channel -> QueueName -> AffAMQP eff AssertQueueOK
```

Checks that a queue exists with the given queue name.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_checkQueue) for details.

#### `deleteQueue`

``` purescript
deleteQueue :: forall eff. Channel -> QueueName -> DeleteQueueOptions -> AffAMQP eff DeleteQueueOK
```

Deletes the queue by the given name.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_deleteQueue) for details.

#### `purgeQueue`

``` purescript
purgeQueue :: forall eff. Channel -> QueueName -> AffAMQP eff PurgeQueueOK
```

Purges the messages from the queue by the given name.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_purgeQueue) for details.

#### `bindQueue`

``` purescript
bindQueue :: forall eff. Channel -> QueueName -> ExchangeName -> RoutingKey -> StrMap Foreign -> AffAMQP eff Unit
```

Asserts a routing path from an exchange to a queue: the given exchange will relay
messages to the given queue, according to the type of the exchange and the given routing key.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_bindQueue) details.

#### `unbindQueue`

``` purescript
unbindQueue :: forall eff. Channel -> QueueName -> ExchangeName -> RoutingKey -> StrMap Foreign -> AffAMQP eff Unit
```

Removes the routing path between the given queue and the given exchange with the given routing key and arguments.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_unbindQueue) for details.

#### `assertExchange`

``` purescript
assertExchange :: forall eff. Channel -> ExchangeName -> ExchangeType -> ExchangeOptions -> AffAMQP eff Unit
```

Asserts an exchange into existence with the given exchange name, type and options.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_assertExchange) for details.

#### `checkExchange`

``` purescript
checkExchange :: forall eff. Channel -> ExchangeName -> AffAMQP eff Unit
```

Checks that the exchange exists by the given name.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_checkExchange) for details.

#### `deleteExchange`

``` purescript
deleteExchange :: forall eff. Channel -> ExchangeName -> DeleteExchangeOptions -> AffAMQP eff Unit
```

Deletes the exchange by the given name.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_deleteExchange) for details.

#### `bindExchange`

``` purescript
bindExchange :: forall eff. Channel -> ExchangeName -> ExchangeName -> RoutingKey -> StrMap Foreign -> AffAMQP eff Unit
```

Binds an exchange to another exchange. The exchange named by `destExchange` will receive messages
from the exchange named by `sourceExchange`, according to the type of the source and the given
routing key.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_bindExchange) for details.

#### `unbindExchange`

``` purescript
unbindExchange :: forall eff. Channel -> ExchangeName -> ExchangeName -> RoutingKey -> StrMap Foreign -> AffAMQP eff Unit
```

Removes a binding from an exchange to another exchange.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_unbindExchange) for details.

#### `publish`

``` purescript
publish :: forall eff. Channel -> ExchangeName -> RoutingKey -> Buffer -> PublishOptions -> AffAMQP eff Unit
```

Publish a single message to the given exchange with the given routing key, and the given publish
options. The message content is given as a `Buffer`.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_publish) for details.

#### `sendToQueue`

``` purescript
sendToQueue :: forall eff. Channel -> QueueName -> Buffer -> PublishOptions -> AffAMQP eff Unit
```

Sends a single message with the content given as a `Buffer` to the given queue, bypassing routing.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_sendToQueue) for details.

#### `consume`

``` purescript
consume :: forall eff. Channel -> QueueName -> ConsumeOptions -> (Maybe Message -> EffAMQP eff Unit) -> AffAMQP eff ConsumeOK
```

Sets up a consumer for the given queue and consume options, with a callback to be invoked with each message.
The callback receives `Nothing` if the consumer is cancelled by the broker. Returns the consumer tag.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_consume) for details.

#### `cancel`

``` purescript
cancel :: forall eff. Channel -> String -> AffAMQP eff Unit
```

Cancels the consumer identified by the given consumer tag.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_cancel) for details.

#### `get`

``` purescript
get :: forall eff. Channel -> QueueName -> GetOptions -> AffAMQP eff (Maybe Message)
```

Gets a message from the given queue. If there are no messages in the queue, returns `Nothing`.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_get) for details.

#### `ack`

``` purescript
ack :: forall eff. Channel -> String -> EffAMQP eff Unit
```

Acknowledges a message given its delivery tag.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_ack) for details.

#### `ackAllUpTo`

``` purescript
ackAllUpTo :: forall eff. Channel -> String -> EffAMQP eff Unit
```

Acknowledges all messages up to the message with the given delivery tag.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_ack) for details.

#### `ackAll`

``` purescript
ackAll :: forall eff. Channel -> EffAMQP eff Unit
```

Acknowledges all outstanding messages on the channel.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_ackAll) for details.

#### `nack`

``` purescript
nack :: forall eff. Channel -> String -> Boolean -> EffAMQP eff Unit
```

Rejects a message given its delivery tag. If the boolean param is true, the server requeues the
message, else it drops it.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_nack) for details.

#### `nackAllUpTo`

``` purescript
nackAllUpTo :: forall eff. Channel -> String -> Boolean -> EffAMQP eff Unit
```

Rejects all messages up to the message with the given delivery tag. If the boolean param is true,
the server requeues the messages, else it drops them.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_nack) for details.

#### `nackAll`

``` purescript
nackAll :: forall eff. Channel -> Boolean -> EffAMQP eff Unit
```

Rejects all outstanding messages on the channel. If the boolean param is true,
the server requeues the messages, else it drops them.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_nackAll) for details.

#### `prefetch`

``` purescript
prefetch :: forall eff. Channel -> Int -> AffAMQP eff Unit
```

Sets the prefetch count for this channel.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_prefetch) for details.

#### `recover`

``` purescript
recover :: forall eff. Channel -> AffAMQP eff Unit
```

Requeues unacknowledged messages on this channel.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_recover) for details.

#### `onConnectionClose`

``` purescript
onConnectionClose :: forall eff. Connection -> (Maybe Error -> EffAMQP eff Unit) -> EffAMQP eff Unit
```

Registers an event handler to the connection which is triggered when the connection closes.
If the connection closes because of an error, the handler is called with `Just error`, else
with `Nothing`.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#model_events) for details.

#### `onConnectionError`

``` purescript
onConnectionError :: forall eff. Connection -> (Error -> EffAMQP eff Unit) -> EffAMQP eff Unit
```

Registers an event handler to the connection which is triggered when the connection errors out.
The handler is called with the error.

#### `onConnectionBlocked`

``` purescript
onConnectionBlocked :: forall eff. Connection -> (String -> EffAMQP eff Unit) -> EffAMQP eff Unit
```

Registers an event handler to the connection which is triggered when the RabbitMQ server
decides to block the connection. The handler is called with the reason for blocking.

#### `onConnectionUnblocked`

``` purescript
onConnectionUnblocked :: forall eff. Connection -> EffAMQP eff Unit -> EffAMQP eff Unit
```

Registers an event handler to the connection which is triggered when the RabbitMQ server
decides to unblock the connection. The handler is called with no arguments.

#### `onChannelClose`

``` purescript
onChannelClose :: forall eff. Channel -> EffAMQP eff Unit -> EffAMQP eff Unit
```

Registers an event handler to the channel which is triggered when the channel closes.
The handler is called with no arguments.
See [amqplib docs](http://www.squaremobius.net/amqp.node/channel_api.html#channel_events) for details.

#### `onChannelError`

``` purescript
onChannelError :: forall eff. Channel -> (Error -> EffAMQP eff Unit) -> EffAMQP eff Unit
```

Registers an event handler to the channel which is triggered when the channel errors out.
The handler is called with the error.

#### `onChannelReturn`

``` purescript
onChannelReturn :: forall eff. Channel -> (Message -> EffAMQP eff Unit) -> EffAMQP eff Unit
```

Registers an event handler to the channel which is triggered when a message published with
the mandatory flag cannot be routed and is returned to the sending channel. The handler is
called with the returned message.

#### `onChannelDrain`

``` purescript
onChannelDrain :: forall eff. Channel -> EffAMQP eff Unit -> EffAMQP eff Unit
```

Registers an event handler to the channel which is triggered when the channel's write buffer
is emptied. The handler is called with no arguments.

#### `withChannel`

``` purescript
withChannel :: forall eff a. Connection -> (Channel -> AffAMQP eff a) -> AffAMQP eff a
```

A convenience function for creating a channel, doing some action with it, and then automatically closing
it, even in case of errors.


### Re-exported from Node.AMQP.FFI:

#### `EffAMQP`

``` purescript
type EffAMQP e a = Eff (amqp :: AMQP | e) a
```

#### `AffAMQP`

``` purescript
type AffAMQP e a = Aff (amqp :: AMQP | e) a
```

### Re-exported from Node.AMQP.Types:

#### `RoutingKey`

``` purescript
type RoutingKey = String
```

An AMQP routing key.

#### `QueueOptions`

``` purescript
type QueueOptions = { exclusive :: Maybe Boolean, durable :: Maybe Boolean, autoDelete :: Maybe Boolean, arguments :: StrMap Foreign, messageTTL :: Maybe Milliseconds, expires :: Maybe Milliseconds, deadLetterExchange :: Maybe String, deadLetterRoutingKey :: Maybe RoutingKey, maxLength :: Maybe Int, maxPriority :: Maybe Int }
```

Options used to create a queue:

- `exclusive`: if true, the queue is used by only one connection and is deleted when that connection closes.
- `durable`: if true, the queue survives broker restarts.
- `autoDelete`: if true, the queue is deleted when there is no consumers for it.
- `messageTTL`: if specified, expires messages arriving in the queue after n milliseconds.
- `expires`: if specified, the queue is destroyed after n milliseconds of disuse, where "use"
means having consumers, being asserted or checked, or being polled.
- `deadLetterExchange`: if specified, an exchange to which messages discarded from the queue are resent to.
- `deadLetterRoutingKey`: if specified, set as the routing key for the discarded messages.
- `maxLength`: if specified, the maximum number of messages the queue holds.
- `maxPriority`: if specified, makes the queue a [priority queue](http://www.rabbitmq.com/priority.html).
- `arguments`: additional arguments.

See <http://www.squaremobius.net/amqp.node/channel_api.html#channel_assertQueue> for details.

#### `QueueName`

``` purescript
type QueueName = String
```

An AMQP queue name.

#### `PurgeQueueOK`

``` purescript
type PurgeQueueOK = { messageCount :: Int }
```

Reply from the server for purging a queue. Contains the count of the mssages purged from the queue.

#### `PublishOptions`

``` purescript
type PublishOptions = { expiration :: Maybe Milliseconds, userId :: Maybe String, cc :: Array RoutingKey, bcc :: Array RoutingKey, priority :: Maybe Int, persistent :: Maybe Boolean, mandatory :: Maybe Boolean, contentType :: Maybe String, contentEncoding :: Maybe String, headers :: StrMap Foreign, correlationId :: Maybe String, replyTo :: Maybe QueueName, messageId :: Maybe String, timestamp :: Maybe Instant, "type" :: Maybe String, appId :: Maybe String }
```

Options to publish a message:

- `expiration`: if specified, the message is discarded from a queue once it has been there
longer than the given number of milliseconds.
- `userId`: if specified, RabbitMQ compares it to the username supplied when opening the connection,
and rejects the messages for which it does not match.
- `cc`: an array of routing keys; messages are routed to these routing keys in addition to the
given routing key.
- `bcc`: like `cc`, except that the value is not sent in the message headers to consumers.
- `priority`: if specified, a priority for the message.
- `persistent`: if true, the message survives broker restarts provided it is in a queue that
also survives restarts.
- `mandatory`: if true, the message is returned if it is not routed to a queue.
- `contentType`: a MIME type for the message content.
- `contentEncoding`: a MIME encoding for the message content.
- `headers`: application specific headers to be carried along with the message content.
- `correlationId`: usually used to match replies to requests, or similar.
- `replyTo`: often used to name a queue to which the receiving application must send replies, in an RPC scenario.
- `messageId`: arbitrary application-specific identifier for the message.
- `timestamp`: a timestamp for the message.
- `type`: an arbitrary application-specific type for the message.
- `appId`: an arbitrary identifier for the originating application.

See <http://www.squaremobius.net/amqp.node/channel_api.html#channel_publish> for details.

#### `MessageProperties`

``` purescript
type MessageProperties = { expiration :: Maybe Milliseconds, userId :: Maybe String, priority :: Maybe Int, persistent :: Maybe Boolean, contentType :: Maybe String, contentEncoding :: Maybe String, headers :: StrMap Foreign, correlationId :: Maybe String, replyTo :: Maybe QueueName, messageId :: Maybe String, timestamp :: Maybe Instant, "type" :: Maybe String, appId :: Maybe String }
```

Properties of a message received by a consumer. A subset of the `PublishOptions` fields.

#### `MessageFields`

``` purescript
type MessageFields = { deliveryTag :: String, consumerTag :: String, exchange :: ExchangeName, routingKey :: RoutingKey, redelivered :: Boolean }
```

Fields of a message received by a consumer:

- `deliveryTag`: a serial number for the message.
- `consumerTag`: an identifier for the consumer for which the message is destined.
- `exchange`: the exchange to which the message was published.
- `routingKey`: the routing key with which the message was published.
- `redelivered`: if true, indicates that this message has been delivered before and has been
handed back to the server.

#### `Message`

``` purescript
type Message = { content :: Buffer, fields :: MessageFields, properties :: MessageProperties }
```

A message received by a consumer:

- `content`: the content of the message a buffer.
- `fields`: the message fields.
- `properties`: the message properties.

#### `GetOptions`

``` purescript
type GetOptions = { noAck :: Maybe Boolean }
```

Options used to get a message from a queue:

- `noAck`: if true, the broker does expect an acknowledgement of the messages delivered to
this consumer. It dequeues messages as soon as they've been sent down the wire.

#### `ExchangeType`

``` purescript
data ExchangeType
  = Direct
  | Topic
  | Headers
  | Fanout
```

Types of AMQP exchanges. See <https://www.rabbitmq.com/tutorials/amqp-concepts.html> for details.

##### Instances
``` purescript
Generic ExchangeType _
Show ExchangeType
Eq ExchangeType
```

#### `ExchangeOptions`

``` purescript
type ExchangeOptions = { durable :: Maybe Boolean, internal :: Maybe Boolean, autoDelete :: Maybe Boolean, alternateExchange :: Maybe String, arguments :: StrMap Foreign }
```

Options to create an exchange:

- `durable`: if true, the exchange survives broker restarts.
- `internal`: if true, messages cannot be published directly to the exchange.
- `autoDelete`: if true, the exchange is destroyed once it has no bindings.
- `alternateExchange`: if specified, an exchange to send messages to if this exchange can't route them to any queues.
- `arguments`: additional arguments.

See <http://www.squaremobius.net/amqp.node/channel_api.html#channel_assertExchange> for details.

#### `ExchangeName`

``` purescript
type ExchangeName = String
```

An AMQP exchange name.

#### `DeleteQueueOptions`

``` purescript
type DeleteQueueOptions = { ifUnused :: Maybe Boolean, ifEmpty :: Maybe Boolean }
```

Options used to delete a queue:

- `ifUnused`: if true and the queue has consumers, it is not deleted and the channel is closed.
- `ifEmpty`: if true and the queue contains messages, the queue is not deleted and the channel is closed.

See <http://www.squaremobius.net/amqp.node/channel_api.html#channel_deleteQueue> for details.

#### `DeleteQueueOK`

``` purescript
type DeleteQueueOK = { messageCount :: Int }
```

Reply from the server for deleting a queue. Contains the count of the mssages in the queue.

#### `DeleteExchangeOptions`

``` purescript
type DeleteExchangeOptions = { ifUnused :: Maybe Boolean }
```

Options to delete an exchange:
- `ifUnused`: if true and the exchange has bindings, it is not deleted and the channel is closed.

See <http://www.squaremobius.net/amqp.node/channel_api.html#channel_deleteExchange> for details.

#### `ConsumeOptions`

``` purescript
type ConsumeOptions = { consumerTag :: Maybe String, noLocal :: Maybe Boolean, noAck :: Maybe Boolean, exclusive :: Maybe Boolean, priority :: Maybe Int, arguments :: StrMap Foreign }
```

Options used to consume message from a queue:

- `consumerTag`: an identifier for this consumer, must not be already in use on the channel.
- `noLocal`: if true, the broker does not deliver messages to the consumer if they were also
published on this connection. RabbitMQ doesn't implement it, and will ignore it.
- `noAck`: if true, the broker does expect an acknowledgement of the messages delivered to
this consumer. It dequeues messages as soon as they've been sent down the wire.
- `exclusive`: if true, the broker does not let anyone else consume from this queue.
- `priority`: gives a priority to the consumer. Higher priority consumers get messages in
preference to lower priority consumers.
- `arguments`: additional arguments.

See <http://www.squaremobius.net/amqp.node/channel_api.html#channel_consume> for details.

#### `ConsumeOK`

``` purescript
type ConsumeOK = { consumerTag :: String }
```

Reply from the server for setting up a consumer. Contains the consumer tag which is the unique
identifier for this consumer.

#### `Connection`

``` purescript
data Connection :: Type
```

An AMQP connection.

#### `ConnectOptions`

``` purescript
type ConnectOptions = { frameMax :: Int, channelMax :: Int, heartbeat :: Seconds }
```

Options used to connect to the AMQP server. See
<http://www.squaremobius.net/amqp.node/channel_api.html#connect> for details.

#### `Channel`

``` purescript
data Channel :: Type
```

An AMQP Channel.

#### `AssertQueueOK`

``` purescript
type AssertQueueOK = { queue :: String, messageCount :: Int, consumerCount :: Int }
```

Reply from the server for asserting a queue. Contains the
name of queue asserted, the count of the messages in the queue, and the count of the consumers of
the queue.

#### `AMQP`

``` purescript
data AMQP :: Effect
```

The effect for computations which talk to an AMQP server.

#### `defaultQueueOptions`

``` purescript
defaultQueueOptions :: QueueOptions
```

Default options to create a queue. Every field is set to `Nothing` or `empty`.

#### `defaultPublishOptions`

``` purescript
defaultPublishOptions :: PublishOptions
```

Default options to publish a message. Every field is set to `Nothing`.

#### `defaultGetOptions`

``` purescript
defaultGetOptions :: GetOptions
```

Default options to get a message from a queue. Every field is set to `Nothing`.

#### `defaultExchangeOptions`

``` purescript
defaultExchangeOptions :: ExchangeOptions
```

Default options to create an exchange. Every field is set to `Nothing` or `empty`.

#### `defaultDeleteQueueOptions`

``` purescript
defaultDeleteQueueOptions :: DeleteQueueOptions
```

Default options to delete a queue. Every field is set to `Nothing`.

#### `defaultDeleteExchangeOptions`

``` purescript
defaultDeleteExchangeOptions :: DeleteExchangeOptions
```

Default options to delete an exchange. Every field is set to `Nothing`.

#### `defaultConsumeOptions`

``` purescript
defaultConsumeOptions :: ConsumeOptions
```

Default options to consume messages from a queue. Every field is set to `Nothing` or `empty`.

#### `defaultConnectOptions`

``` purescript
defaultConnectOptions :: ConnectOptions
```

Default connection options.

