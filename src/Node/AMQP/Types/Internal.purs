module Node.AMQP.Types.Internal where

import Node.AMQP.Types
import Prelude

import Control.Monad.Eff (kind Effect)
import Data.DateTime.Instant (instant, unInstant)
import Data.Foreign (Foreign)
import Data.Foreign.Class (class Encode, encode)
import Data.Foreign.Generic (defaultOptions, genericEncode)
import Data.Foreign.NullOrUndefined (NullOrUndefined(..))
import Data.Generic.Rep (class Generic)
import Data.Int (floor, hexadecimal, toStringAs)
import Data.Newtype (unwrap)
import Data.Nullable (Nullable, toMaybe)
import Data.StrMap as StrMap
import Data.Time.Duration (Milliseconds(..), Seconds(..))
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
                      { exclusive            :: NullOrUndefined Boolean
                      , durable              :: NullOrUndefined Boolean
                      , autoDelete           :: NullOrUndefined Boolean
                      , arguments            :: StrMap.StrMap Foreign
                      , messageTtl           :: NullOrUndefined Number
                      , expires              :: NullOrUndefined Number
                      , deadLetterExchange   :: NullOrUndefined String
                      , deadLetterRoutingKey :: NullOrUndefined String
                      , maxLength            :: NullOrUndefined Int
                      , maxPriority          :: NullOrUndefined Int
                      }

derive instance genericQueueOptions' :: Generic QueueOptions' _

instance encodeQueueOptions' :: Encode QueueOptions' where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

fromQueueOptions :: QueueOptions -> QueueOptions'
fromQueueOptions opts = QueueOptions'
                      { exclusive           :  NullOrUndefined opts.exclusive
                      , durable             :  NullOrUndefined opts.durable
                      , autoDelete          :  NullOrUndefined opts.autoDelete
                      , arguments           :  opts.arguments
                      , messageTtl          :  NullOrUndefined (unwrap <$> opts.messageTTL)
                      , expires             :  NullOrUndefined (unwrap <$> opts.expires)
                      , deadLetterExchange  :  NullOrUndefined opts.deadLetterExchange
                      , deadLetterRoutingKey:  NullOrUndefined opts.deadLetterRoutingKey
                      , maxLength           :  NullOrUndefined opts.maxLength
                      , maxPriority         :  NullOrUndefined opts.maxPriority
                      }

newtype DeleteQueueOptions' = DeleteQueueOptions'
                            { ifUnused :: NullOrUndefined Boolean
                            , ifEmpty  :: NullOrUndefined Boolean }

derive instance genericDeleteQueueOptions' :: Generic DeleteQueueOptions' _

instance encodeDeleteQueueOptions' :: Encode DeleteQueueOptions' where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

fromDeleteQueueOptions :: DeleteQueueOptions -> DeleteQueueOptions'
fromDeleteQueueOptions opts = DeleteQueueOptions'
                            { ifUnused: NullOrUndefined opts.ifUnused
                            , ifEmpty : NullOrUndefined opts.ifEmpty
                            }

newtype ExchangeOptions' = ExchangeOptions'
                         { durable           :: NullOrUndefined Boolean
                         , internal          :: NullOrUndefined Boolean
                         , autoDelete        :: NullOrUndefined Boolean
                         , alternateExchange :: NullOrUndefined String
                         , arguments         :: StrMap.StrMap Foreign
                         }

derive instance genericExchangeOptions' :: Generic ExchangeOptions' _

instance encodeExchangeOptions' :: Encode ExchangeOptions' where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

fromExchangeOptions :: ExchangeOptions -> ExchangeOptions'
fromExchangeOptions opts = ExchangeOptions'
                         { durable          : NullOrUndefined opts.durable
                         , internal         : NullOrUndefined opts.internal
                         , autoDelete       : NullOrUndefined opts.autoDelete
                         , alternateExchange: NullOrUndefined opts.alternateExchange
                         , arguments        : opts.arguments
                         }

newtype DeleteExchangeOptions' = DeleteExchangeOptions' { ifUnused :: NullOrUndefined Boolean }

derive instance genericDeleteExchangeOptions' :: Generic DeleteExchangeOptions' _

instance encodeDeleteExchangeOptions' :: Encode DeleteExchangeOptions' where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

fromDeleteExchangeOptions :: DeleteExchangeOptions -> DeleteExchangeOptions'
fromDeleteExchangeOptions opts = DeleteExchangeOptions' { ifUnused: NullOrUndefined opts.ifUnused }

newtype PublishOptions' = PublishOptions'
                        { expiration      :: NullOrUndefined String
                        , userId          :: NullOrUndefined String
                        , "CC"            :: Array RoutingKey
                        , "BCC"           :: Array RoutingKey
                        , priority        :: NullOrUndefined Int
                        , persistent      :: NullOrUndefined Boolean
                        , mandatory       :: NullOrUndefined Boolean
                        , contentType     :: NullOrUndefined String
                        , contentEncoding :: NullOrUndefined String
                        , headers         :: StrMap.StrMap Foreign
                        , correlationId   :: NullOrUndefined String
                        , replyTo         :: NullOrUndefined QueueName
                        , messageId       :: NullOrUndefined String
                        , timestamp       :: NullOrUndefined Number
                        , type            :: NullOrUndefined String
                        , appId           :: NullOrUndefined String
                        }

derive instance genericPublishOptions' :: Generic PublishOptions' _

instance encodePublishOptions' :: Encode PublishOptions' where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

fromPublishOptions :: PublishOptions -> PublishOptions'
fromPublishOptions opts = PublishOptions'
                        { expiration     : NullOrUndefined (show <$> opts.expiration)
                        , userId         : NullOrUndefined opts.userId
                        , "CC"           : opts.cc
                        , "BCC"          : opts.bcc
                        , priority       : NullOrUndefined opts.priority
                        , persistent     : NullOrUndefined opts.persistent
                        , mandatory      : NullOrUndefined opts.mandatory
                        , contentType    : NullOrUndefined opts.contentType
                        , contentEncoding: NullOrUndefined opts.contentEncoding
                        , headers        : opts.headers
                        , correlationId  : NullOrUndefined opts.correlationId
                        , replyTo        : NullOrUndefined opts.replyTo
                        , messageId      : NullOrUndefined opts.messageId
                        , timestamp      : NullOrUndefined ((unwrap <<< unInstant) <$> opts.timestamp)
                        , type           : NullOrUndefined opts.type
                        , appId          : NullOrUndefined opts.appId
                        }

newtype MessageProperties' = MessageProperties'
                           { expiration      :: Nullable Number
                           , userId          :: Nullable String
                           , priority        :: Nullable Int
                           , deliveryMode    :: Nullable Int
                           , contentType     :: Nullable String
                           , contentEncoding :: Nullable String
                           , headers         :: StrMap.StrMap Foreign
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
                        { consumerTag :: NullOrUndefined String
                        , noLocal     :: NullOrUndefined Boolean
                        , noAck       :: NullOrUndefined Boolean
                        , exclusive   :: NullOrUndefined Boolean
                        , priority    :: NullOrUndefined Int
                        , arguments   :: StrMap.StrMap Foreign
                        }

derive instance genericConsumeOptions' :: Generic ConsumeOptions' _

instance encodeConsumeOptions' :: Encode ConsumeOptions' where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

fromConsumeOptions :: ConsumeOptions -> ConsumeOptions'
fromConsumeOptions opts = ConsumeOptions'
                        { consumerTag: NullOrUndefined opts.consumerTag
                        , noLocal    : NullOrUndefined opts.noLocal
                        , noAck      : NullOrUndefined opts.noAck
                        , exclusive  : NullOrUndefined opts.exclusive
                        , priority   : NullOrUndefined opts.priority
                        , arguments  : opts.arguments
                        }

newtype GetOptions' = GetOptions' { noAck :: NullOrUndefined Boolean }

derive instance genericGetOptions' :: Generic GetOptions' _

instance encodeGetOptions' :: Encode GetOptions' where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

fromGetOptions :: GetOptions -> GetOptions'
fromGetOptions opts = GetOptions' { noAck: NullOrUndefined opts.noAck }
