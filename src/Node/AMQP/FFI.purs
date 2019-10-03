module Node.AMQP.FFI where

import Node.AMQP.Types
import Node.AMQP.Types.Internal (Message')
import Prelude (Unit)

import Effect (Effect)
import Effect.Exception (Error)
import Foreign (Foreign)
import Data.Function.Uncurried (Fn2, Fn3, Fn4, Fn5, Fn6, Fn7, Fn1)
import Data.Nullable (Nullable)
import Node.Buffer (Buffer)


type ECb a = Error -> Effect a
type SCb r a = r -> Effect a

foreign import _connect :: forall a.
  Fn3 String (ECb a) (SCb Connection a) (Effect a)

foreign import _close :: forall a.
  Fn3 Connection (ECb a) (SCb Unit a) (Effect a)

foreign import _createChannel :: forall a.
  Fn3 Connection (ECb a) (SCb Channel a) (Effect a)

foreign import _closeChannel :: forall a.
  Fn3 Channel (ECb a) (SCb Unit a) (Effect a)

foreign import _assertQueue :: forall a.
  Fn5 Channel QueueName Foreign (ECb a) (SCb AssertQueueOK a) (Effect a)

foreign import _checkQueue :: forall a.
  Fn4 Channel QueueName (ECb a) (SCb AssertQueueOK a) (Effect a)

foreign import _deleteQueue :: forall a.
  Fn5 Channel QueueName Foreign (ECb a) (SCb DeleteQueueOK a) (Effect a)

foreign import _purgeQueue :: forall a.
  Fn4 Channel QueueName (ECb a) (SCb PurgeQueueOK a) (Effect a)

foreign import _bindQueue :: forall a.
  Fn7 Channel QueueName ExchangeName RoutingKey Foreign (ECb a) (SCb Unit a) (Effect a)

foreign import _unbindQueue :: forall a.
  Fn7 Channel QueueName ExchangeName RoutingKey Foreign (ECb a) (SCb Unit a) (Effect a)

foreign import _assertExchange :: forall a.
  Fn6 Channel ExchangeName String Foreign (ECb a) (SCb Unit a) (Effect a)

foreign import _checkExchange :: forall a.
  Fn4 Channel ExchangeName (ECb a) (SCb Unit a) (Effect a)

foreign import _deleteExchange :: forall a.
  Fn5 Channel ExchangeName Foreign (ECb a) (SCb Unit a) (Effect a)

foreign import _bindExchange :: forall a.
  Fn7 Channel QueueName QueueName RoutingKey Foreign (ECb a) (SCb Unit a) (Effect a)

foreign import _unbindExchange :: forall a.
  Fn7 Channel QueueName QueueName RoutingKey Foreign (ECb a) (SCb Unit a) (Effect a)

foreign import _publish :: forall a.
  Fn6 Channel ExchangeName RoutingKey Buffer Foreign (SCb Unit a) (Effect a)

foreign import _sendToQueue :: forall a.
  Fn5 Channel QueueName Buffer Foreign (SCb Unit a) (Effect a)

foreign import _consume :: forall a.
  Fn6 Channel QueueName (SCb (Nullable Message') Unit) Foreign (ECb a) (SCb ConsumeOK a) (Effect a)

foreign import _cancel :: forall a.
  Fn4 Channel String (ECb a) (SCb Unit a) (Effect a)

foreign import _get :: forall a.
  Fn5 Channel QueueName Foreign (ECb a) (SCb (Nullable Message') a) (Effect a)

foreign import _ack :: forall a.
  Fn3 Channel String Boolean (Effect a)

foreign import _nack :: forall a.
  Fn4 Channel String Boolean Boolean (Effect a)

foreign import _ackAll :: forall a.
  Fn1 Channel (Effect a)

foreign import _nackAll :: forall a.
  Fn2 Channel Boolean (Effect a)

foreign import _prefetch :: forall a.
  Fn2 Channel Int (Effect a)

foreign import _recover :: forall a.
  Fn3 Channel (ECb a) (SCb Unit a) (Effect a)

foreign import _onConnectionClose :: forall a.
  Fn2 Connection (SCb (Nullable Error) Unit) (Effect a)

foreign import _onConnectionError :: forall a.
  Fn2 Connection (SCb Error Unit) (Effect a)

foreign import _onConnectionBlocked :: forall a.
  Fn2 Connection (SCb String Unit) (Effect a)

foreign import _onConnectionUnblocked :: forall a.
  Fn2 Connection (Effect Unit) (Effect a)

foreign import _onChannelClose :: forall a.
  Fn2 Channel (Effect Unit) (Effect a)

foreign import _onChannelError :: forall a.
  Fn2 Channel (SCb Error Unit) (Effect a)

foreign import _onChannelReturn :: forall a.
  Fn2 Channel (SCb Message' Unit) (Effect a)

foreign import _onChannelDrain :: forall a.
  Fn2 Channel (Effect Unit) (Effect a)
