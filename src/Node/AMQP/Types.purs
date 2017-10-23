module Node.AMQP.Types where

import Prelude

import Control.Monad.Eff (kind Effect)
import Control.Plus (empty)
import Data.DateTime.Instant (Instant)
import Data.Foreign (Foreign)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Eq (genericEq)
import Data.Generic.Rep.Show (genericShow)
import Data.Maybe (Maybe(..))
import Data.StrMap as StrMap
import Data.String (toLower)
import Data.Time.Duration (Milliseconds, Seconds(..))
import Node.Buffer (Buffer)

-- | The effect for computations which talk to an AMQP server.
foreign import data AMQP       :: Effect

-- | An AMQP connection.
foreign import data Connection :: Type

-- | An AMQP Channel.
foreign import data Channel    :: Type

-- | An AMQP queue name.
type QueueName = String

-- | An AMQP exchange name.
type ExchangeName = String

-- | An AMQP routing key.
type RoutingKey = String

-- | Options used to connect to the AMQP server. See
-- | <http://www.squaremobius.net/amqp.node/channel_api.html#connect> for details.
type ConnectOptions = { frameMax   :: Int
                      , channelMax :: Int
                      , heartbeat  :: Seconds
                      }

-- | Default connection options.
defaultConnectOptions :: ConnectOptions
defaultConnectOptions = { frameMax  : 4096
                        , channelMax: 0
                        , heartbeat : Seconds 5.0
                        }

-- | Reply from the server for asserting a queue. Contains the
-- | name of queue asserted, the count of the messages in the queue, and the count of the consumers of
-- | the queue.
type AssertQueueOK = { queue :: String, messageCount :: Int, consumerCount :: Int }

-- | Reply from the server for deleting a queue. Contains the count of the mssages in the queue.
type DeleteQueueOK = { messageCount :: Int }

-- | Reply from the server for purging a queue. Contains the count of the mssages purged from the queue.
type PurgeQueueOK = { messageCount :: Int }

-- | Types of AMQP exchanges. See <https://www.rabbitmq.com/tutorials/amqp-concepts.html> for details.
data ExchangeType = Direct
                  | Topic
                  | Headers
                  | Fanout

derive instance genericExchangeType :: Generic ExchangeType _

instance showExchangeType :: Show ExchangeType where
  show = genericShow >>> toLower

instance eqExchangeType :: Eq ExchangeType where
  eq = genericEq

-- | Options used to create a queue:
-- | - `exclusive`: if true, the queue is used by only one connection and is deleted when that connection closes.
-- | - `durable`: if true, the queue survives broker restarts.
-- | - `autoDelete`: if true, the queue is deleted when there is no consumers for it.
-- | - `messageTTL`: if specified, expires messages arriving in the queue after n milliseconds.
-- | - `expires`: if specified, the queue is destroyed after n milliseconds of disuse, where "use"
-- | means having consumers, being asserted or checked, or being polled.
-- | - `deadLetterExchange`: if specified, an exchange to which messages discarded from the queue are resent to.
-- | - `deadLetterRoutingKey`: if specified, set as the routing key for the discarded messages.
-- | - `maxLength`: if specified, the maximum number of messages the queue holds.
-- | - `maxPriority`: if specified, makes the queue a [priority queue](http://www.rabbitmq.com/priority.html).
-- | - `arguments`: additional arguments.
-- |
-- | See <http://www.squaremobius.net/amqp.node/channel_api.html#channel_assertQueue> for details.
type QueueOptions = { exclusive            :: Maybe Boolean
                    , durable              :: Maybe Boolean
                    , autoDelete           :: Maybe Boolean
                    , arguments            :: StrMap.StrMap Foreign
                    , messageTTL           :: Maybe Milliseconds
                    , expires              :: Maybe Milliseconds
                    , deadLetterExchange   :: Maybe String
                    , deadLetterRoutingKey :: Maybe RoutingKey
                    , maxLength            :: Maybe Int
                    , maxPriority          :: Maybe Int
                    }

-- | Default options to create a queue. Every field is set to `Nothing` or `empty`.
defaultQueueOptions :: QueueOptions
defaultQueueOptions = { exclusive           : Nothing
                      , durable             : Nothing
                      , autoDelete          : Nothing
                      , arguments           : StrMap.empty
                      , messageTTL          : Nothing
                      , expires             : Nothing
                      , deadLetterExchange  : Nothing
                      , deadLetterRoutingKey: Nothing
                      , maxLength           : Nothing
                      , maxPriority         : Nothing
                      }

-- | Options used to delete a queue:
-- | - `ifUnused`: if true and the queue has consumers, it is not deleted and the channel is closed.
-- | - `ifEmpty`: if true and the queue contains messages, the queue is not deleted and the channel is closed.
-- |
-- | See <http://www.squaremobius.net/amqp.node/channel_api.html#channel_deleteQueue> for details.
type DeleteQueueOptions = { ifUnused :: Maybe Boolean, ifEmpty :: Maybe Boolean }

-- | Default options to delete a queue. Every field is set to `Nothing`.
defaultDeleteQueueOptions :: DeleteQueueOptions
defaultDeleteQueueOptions = { ifUnused: empty, ifEmpty: empty }

-- | Options to create an exchange:
-- | - `durable`: if true, the exchange survives broker restarts.
-- | - `internal`: if true, messages cannot be published directly to the exchange.
-- | - `autoDelete`: if true, the exchange is destroyed once it has no bindings.
-- | - `alternateExchange`: if specified, an exchange to send messages to if this exchange can't route them to any queues.
-- | - `arguments`: additional arguments.
-- |
-- | See <http://www.squaremobius.net/amqp.node/channel_api.html#channel_assertExchange> for details.
type ExchangeOptions = { durable           :: Maybe Boolean
                       , internal          :: Maybe Boolean
                       , autoDelete        :: Maybe Boolean
                       , alternateExchange :: Maybe String
                       , arguments         :: StrMap.StrMap Foreign
                       }

-- | Default options to create an exchange. Every field is set to `Nothing` or `empty`.
defaultExchangeOptions :: ExchangeOptions
defaultExchangeOptions = { durable          : Nothing
                         , internal         : Nothing
                         , autoDelete       : Nothing
                         , alternateExchange: Nothing
                         , arguments        : StrMap.empty
                         }

-- | Options to delete an exchange:
-- | - `ifUnused`: if true and the exchange has bindings, it is not deleted and the channel is closed.
-- |
-- | See <http://www.squaremobius.net/amqp.node/channel_api.html#channel_deleteExchange> for details.
type DeleteExchangeOptions = { ifUnused :: Maybe Boolean }

-- | Default options to delete an exchange. Every field is set to `Nothing`.
defaultDeleteExchangeOptions :: DeleteExchangeOptions
defaultDeleteExchangeOptions = { ifUnused: Nothing }

-- | Options to publish a message:
-- | - `expiration`: if specified, the message is discarded from a queue once it has been there
-- | longer than the given number of milliseconds.
-- | - `userId`: if specified, RabbitMQ compares it to the username supplied when opening the connection,
-- | and rejects the messages for which it does not match.
-- | - `cc`: an array of routing keys; messages are routed to these routing keys in addition to the
-- | given routing key.
-- | - `bcc`: like `cc`, except that the value is not sent in the message headers to consumers.
-- | - `priority`: if specified, a priority for the message.
-- | - `persistent`: if true, the message survives broker restarts provided it is in a queue that
-- | also survives restarts.
-- | - `mandatory`: if true, the message is returned if it is not routed to a queue.
-- | - `contentType`: a MIME type for the message content.
-- | - `contentEncoding`: a MIME encoding for the message content.
-- | - `headers`: application specific headers to be carried along with the message content.
-- | - `correlationId`: usually used to match replies to requests, or similar.
-- | - `replyTo`: often used to name a queue to which the receiving application must send replies, in an RPC scenario.
-- | - `messageId`: arbitrary application-specific identifier for the message.
-- | - `timestamp`: a timestamp for the message.
-- | - `type`: an arbitrary application-specific type for the message.
-- | - `appId`: an arbitrary identifier for the originating application.
-- |
-- | See <http://www.squaremobius.net/amqp.node/channel_api.html#channel_publish> for details.
type PublishOptions = { expiration      :: Maybe Milliseconds
                      , userId          :: Maybe String
                      , cc              :: Array RoutingKey
                      , bcc             :: Array RoutingKey
                      , priority        :: Maybe Int
                      , persistent      :: Maybe Boolean
                      , mandatory       :: Maybe Boolean
                      , contentType     :: Maybe String
                      , contentEncoding :: Maybe String
                      , headers         :: StrMap.StrMap Foreign
                      , correlationId   :: Maybe String
                      , replyTo         :: Maybe QueueName
                      , messageId       :: Maybe String
                      , timestamp       :: Maybe Instant
                      , type            :: Maybe String
                      , appId           :: Maybe String
                      }

-- | Default options to publish a message. Every field is set to `Nothing`.
defaultPublishOptions :: PublishOptions
defaultPublishOptions = { expiration     : Nothing
                        , userId         : Nothing
                        , cc             : []
                        , bcc            : []
                        , priority       : Nothing
                        , persistent     : Nothing
                        , mandatory      : Nothing
                        , contentType    : Nothing
                        , contentEncoding: Nothing
                        , headers        : StrMap.empty
                        , correlationId  : Nothing
                        , replyTo        : Nothing
                        , messageId      : Nothing
                        , timestamp      : Nothing
                        , type           : Nothing
                        , appId          : Nothing
                        }

-- | Fields of a message received by a consumer:
-- | - `deliveryTag`: a serial number for the message.
-- | - `consumerTag`: an identifier for the consumer for which the message is destined.
-- | - `exchange`: the exchange to which the message was published.
-- | - `routingKey`: the routing key with which the message was published.
-- | - `redelivered`: if true, indicates that this message has been delivered before and has been
-- | handed back to the server.
type MessageFields = { deliveryTag :: String
                     , consumerTag :: String
                     , exchange    :: ExchangeName
                     , routingKey  :: RoutingKey
                     , redelivered :: Boolean
                     }

-- | Properties of a message received by a consumer. A subset of the `PublishOptions` fields.
type MessageProperties = { expiration      :: Maybe Milliseconds
                         , userId          :: Maybe String
                         , priority        :: Maybe Int
                         , persistent      :: Maybe Boolean
                         , contentType     :: Maybe String
                         , contentEncoding :: Maybe String
                         , headers         :: StrMap.StrMap Foreign
                         , correlationId   :: Maybe String
                         , replyTo         :: Maybe QueueName
                         , messageId       :: Maybe String
                         , timestamp       :: Maybe Instant
                         , type            :: Maybe String
                         , appId           :: Maybe String
                         }

-- | A message received by a consumer:
-- | - `content`: the content of the message a buffer.
-- | - `fields`: the message fields.
-- | - `properties`: the message properties.
type Message = { content    :: Buffer
               , fields     :: MessageFields
               , properties :: MessageProperties
               }

-- | Options used to consume message from a queue:
-- | - `consumerTag`: an identifier for this consumer, must not be already in use on the channel.
-- | - `noLocal`: if true, the broker does not deliver messages to the consumer if they were also
-- | published on this connection. RabbitMQ doesn't implement it, and will ignore it.
-- | - `noAck`: if true, the broker does expect an acknowledgement of the messages delivered to
-- | this consumer. It dequeues messages as soon as they've been sent down the wire.
-- | - `exclusive`: if true, the broker does not let anyone else consume from this queue.
-- | - `priority`: gives a priority to the consumer. Higher priority consumers get messages in
-- | preference to lower priority consumers.
-- | - `arguments`: additional arguments.
-- |
-- | See <http://www.squaremobius.net/amqp.node/channel_api.html#channel_consume> for details.
type ConsumeOptions = { consumerTag :: Maybe String
                      , noLocal     :: Maybe Boolean
                      , noAck       :: Maybe Boolean
                      , exclusive   :: Maybe Boolean
                      , priority    :: Maybe Int
                      , arguments   :: StrMap.StrMap Foreign
                      }

-- | Default options to consume messages from a queue. Every field is set to `Nothing` or `empty`.
defaultConsumeOptions :: ConsumeOptions
defaultConsumeOptions = { consumerTag: Nothing
                        , noLocal    : Nothing
                        , noAck      : Nothing
                        , exclusive  : Nothing
                        , priority   : Nothing
                        , arguments  : StrMap.empty
                        }

-- | Reply from the server for setting up a consumer. Contains the consumer tag which is the unique
-- | identifier for this consumer.
type ConsumeOK = { consumerTag :: String }

-- | Options used to get a message from a queue:
-- | - `noAck`: if true, the broker does expect an acknowledgement of the messages delivered to
-- | this consumer. It dequeues messages as soon as they've been sent down the wire.
type GetOptions = { noAck :: Maybe Boolean }

-- | Default options to get a message from a queue. Every field is set to `Nothing`.
defaultGetOptions :: GetOptions
defaultGetOptions = { noAck: Nothing }
