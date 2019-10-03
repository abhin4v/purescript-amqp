module Node.AMQP.Types.Internal where

import Node.AMQP.Types (ConnectOptions, ConsumeOptions, DeleteExchangeOptions, DeleteQueueOptions, ExchangeOptions, GetOptions, Message, MessageFields, PublishOptions, QueueName, QueueOptions, RoutingKey)
import Prelude (join, show, ($), (<$>), (<<<), (<>), (==), (>>>))

import Data.DateTime.Instant (instant, unInstant)
import Foreign (Foreign)
import Foreign.Class (class Encode, encode)
import Foreign.Generic (defaultOptions, genericEncode)
import Data.Generic.Rep (class Generic)
import Data.Int (floor, hexadecimal, toStringAs)
import Data.Newtype (unwrap)
import Data.Nullable (Nullable, toMaybe)
import Data.Maybe (Maybe)
import Data.Time.Duration (Milliseconds(..), Seconds(..))
import Foreign.Object (Object)
import Node.Buffer (Buffer)

connectUrl :: String -> ConnectOptions -> String
connectUrl url { frameMax, channelMax, heartbeat : (Seconds heartbeat) } =
  url <> "?frame_max=0x" <> toStringAs hexadecimal frameMax
      <> "&channel_max=" <> show channelMax
      <> "&heartbeat=" <> show (floor heartbeat)

encodeQueueOptions :: QueueOptions -> Foreign
encodeQueueOptions = fromQueueOptions >>> encode

encodeDeleteQueueOptions :: DeleteQueueOptions -> Foreign
encodeDeleteQueueOptions = fromDeleteQueueOptions >>> encode

encodeExchangeOptions :: ExchangeOptions -> Foreign
encodeExchangeOptions = fromExchangeOptions >>> encode

encodeDeleteExchangeOptions :: DeleteExchangeOptions -> Foreign
encodeDeleteExchangeOptions = fromDeleteExchangeOptions >>> encode

encodePublishOptions :: PublishOptions -> Foreign
encodePublishOptions = fromPublishOptions >>> encode

encodeConsumeOptions :: ConsumeOptions -> Foreign
encodeConsumeOptions = fromConsumeOptions >>> encode

encodeGetOptions :: GetOptions -> Foreign
encodeGetOptions = fromGetOptions >>> encode

newtype QueueOptions' = QueueOptions'
                      { exclusive            :: Maybe Boolean
                      , durable              :: Maybe Boolean
                      , autoDelete           :: Maybe Boolean
                      , arguments            :: Object Foreign
                      , messageTtl           :: Maybe Number
                      , expires              :: Maybe Number
                      , deadLetterExchange   :: Maybe String
                      , deadLetterRoutingKey :: Maybe String
                      , maxLength            :: Maybe Int
                      , maxPriority          :: Maybe Int
                      }

derive instance genericQueueOptions' :: Generic QueueOptions' _

instance encodeQueueOptions' :: Encode QueueOptions' where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

fromQueueOptions :: QueueOptions -> QueueOptions'
fromQueueOptions opts = QueueOptions'
                      { exclusive           :  opts.exclusive
                      , durable             :  opts.durable
                      , autoDelete          :  opts.autoDelete
                      , arguments           :  opts.arguments
                      , messageTtl          :  (unwrap <$> opts.messageTTL)
                      , expires             :  (unwrap <$> opts.expires)
                      , deadLetterExchange  :  opts.deadLetterExchange
                      , deadLetterRoutingKey:  opts.deadLetterRoutingKey
                      , maxLength           :  opts.maxLength
                      , maxPriority         :  opts.maxPriority
                      }

newtype DeleteQueueOptions' = DeleteQueueOptions'
                            { ifUnused :: Maybe Boolean
                            , ifEmpty  :: Maybe Boolean }

derive instance genericDeleteQueueOptions' :: Generic DeleteQueueOptions' _

instance encodeDeleteQueueOptions' :: Encode DeleteQueueOptions' where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

fromDeleteQueueOptions :: DeleteQueueOptions -> DeleteQueueOptions'
fromDeleteQueueOptions opts = DeleteQueueOptions'
                            { ifUnused: opts.ifUnused
                            , ifEmpty : opts.ifEmpty
                            }

newtype ExchangeOptions' = ExchangeOptions'
                         { durable           :: Maybe Boolean
                         , internal          :: Maybe Boolean
                         , autoDelete        :: Maybe Boolean
                         , alternateExchange :: Maybe String
                         , arguments         :: Object Foreign
                         }

derive instance genericExchangeOptions' :: Generic ExchangeOptions' _

instance encodeExchangeOptions' :: Encode ExchangeOptions' where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

fromExchangeOptions :: ExchangeOptions -> ExchangeOptions'
fromExchangeOptions opts = ExchangeOptions'
                         { durable          : opts.durable
                         , internal         : opts.internal
                         , autoDelete       : opts.autoDelete
                         , alternateExchange: opts.alternateExchange
                         , arguments        : opts.arguments
                         }

newtype DeleteExchangeOptions' = DeleteExchangeOptions' { ifUnused :: Maybe Boolean }

derive instance genericDeleteExchangeOptions' :: Generic DeleteExchangeOptions' _

instance encodeDeleteExchangeOptions' :: Encode DeleteExchangeOptions' where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

fromDeleteExchangeOptions :: DeleteExchangeOptions -> DeleteExchangeOptions'
fromDeleteExchangeOptions opts = DeleteExchangeOptions' { ifUnused: opts.ifUnused }

newtype PublishOptions' = PublishOptions'
                        { expiration      :: Maybe String
                        , userId          :: Maybe String
                        , "CC"            :: Array RoutingKey
                        , "BCC"           :: Array RoutingKey
                        , priority        :: Maybe Int
                        , persistent      :: Maybe Boolean
                        , mandatory       :: Maybe Boolean
                        , contentType     :: Maybe String
                        , contentEncoding :: Maybe String
                        , headers         :: Object Foreign
                        , correlationId   :: Maybe String
                        , replyTo         :: Maybe QueueName
                        , messageId       :: Maybe String
                        , timestamp       :: Maybe Number
                        , type            :: Maybe String
                        , appId           :: Maybe String
                        }

derive instance genericPublishOptions' :: Generic PublishOptions' _

instance encodePublishOptions' :: Encode PublishOptions' where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

fromPublishOptions :: PublishOptions -> PublishOptions'
fromPublishOptions opts = PublishOptions'
                        { expiration     : (show <$> opts.expiration)
                        , userId         : opts.userId
                        , "CC"           : opts.cc
                        , "BCC"          : opts.bcc
                        , priority       : opts.priority
                        , persistent     : opts.persistent
                        , mandatory      : opts.mandatory
                        , contentType    : opts.contentType
                        , contentEncoding: opts.contentEncoding
                        , headers        : opts.headers
                        , correlationId  : opts.correlationId
                        , replyTo        : opts.replyTo
                        , messageId      : opts.messageId
                        , timestamp      : ((unwrap <<< unInstant) <$> opts.timestamp)
                        , type           : opts.type
                        , appId          : opts.appId
                        }

newtype MessageProperties' = MessageProperties'
                           { expiration      :: Nullable Number
                           , userId          :: Nullable String
                           , priority        :: Nullable Int
                           , deliveryMode    :: Nullable Int
                           , contentType     :: Nullable String
                           , contentEncoding :: Nullable String
                           , headers         :: Object Foreign
                           , correlationId   :: Nullable String
                           , replyTo         :: Nullable QueueName
                           , messageId       :: Nullable String
                           , timestamp       :: Nullable Number
                           , type            :: Nullable String
                           , appId           :: Nullable String
                           }

newtype Message' = Message'
                 { content    :: Buffer
                 , fields     :: MessageFields
                 , properties :: MessageProperties'
                 }

toMessage :: Message' -> Message
toMessage (Message' { content, fields, properties: (MessageProperties' props) }) =
  { content, fields, properties: msgProperties }
  where
    msgProperties = { expiration      : Milliseconds <$> toMaybe props.expiration
                    , userId          : toMaybe props.userId
                    , priority        : toMaybe props.priority
                    , persistent      : (_ == 2) <$> toMaybe props.deliveryMode
                    , contentType     : toMaybe props.contentType
                    , contentEncoding : toMaybe props.contentEncoding
                    , headers         : props.headers
                    , correlationId   : toMaybe props.correlationId
                    , replyTo         : toMaybe props.replyTo
                    , messageId       : toMaybe props.messageId
                    , timestamp       : join $ instant <$> (Milliseconds <$> toMaybe props.timestamp)
                    , type            : toMaybe props.type
                    , appId           : toMaybe props.appId
                    }

newtype ConsumeOptions' = ConsumeOptions'
                        { consumerTag :: Maybe String
                        , noLocal     :: Maybe Boolean
                        , noAck       :: Maybe Boolean
                        , exclusive   :: Maybe Boolean
                        , priority    :: Maybe Int
                        , arguments   :: Object Foreign
                        }

derive instance genericConsumeOptions' :: Generic ConsumeOptions' _

instance encodeConsumeOptions' :: Encode ConsumeOptions' where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

fromConsumeOptions :: ConsumeOptions -> ConsumeOptions'
fromConsumeOptions opts = ConsumeOptions'
                        { consumerTag: opts.consumerTag
                        , noLocal    : opts.noLocal
                        , noAck      : opts.noAck
                        , exclusive  : opts.exclusive
                        , priority   : opts.priority
                        , arguments  : opts.arguments
                        }

newtype GetOptions' = GetOptions' { noAck :: Maybe Boolean }

derive instance genericGetOptions' :: Generic GetOptions' _

instance encodeGetOptions' :: Encode GetOptions' where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

fromGetOptions :: GetOptions -> GetOptions'
fromGetOptions opts = GetOptions' { noAck: opts.noAck }
