module Node.AMQP.FFI where

import Node.AMQP.Types
import Node.AMQP.Types.Internal
import Prelude

import Control.Monad.Aff (Aff)
import Control.Monad.Eff (Eff, kind Effect)
import Control.Monad.Eff.Exception (Error)
import Data.Foreign (Foreign)
import Data.Function.Uncurried (Fn2, Fn3, Fn4, Fn5, Fn6, Fn7, Fn1)
import Data.Nullable (Nullable)
import Node.Buffer (Buffer)

type EffAMQP e a = Eff (amqp :: AMQP | e) a
type AffAMQP e a = Aff (amqp :: AMQP | e) a

type ECb e a = Error -> EffAMQP e a
type SCb r e a = r -> EffAMQP e a

foreign import _connect :: forall e a.
  Fn3 String (ECb e a) (SCb Connection e a) (EffAMQP e a)

foreign import _close :: forall e a.
  Fn3 Connection (ECb e a) (SCb Unit e a) (EffAMQP e a)

foreign import _createChannel :: forall e a.
  Fn3 Connection (ECb e a) (SCb Channel e a) (EffAMQP e a)

foreign import _closeChannel :: forall e a.
  Fn3 Channel (ECb e a) (SCb Unit e a) (EffAMQP e a)

foreign import _assertQueue :: forall e a.
  Fn5 Channel QueueName Foreign (ECb e a) (SCb AssertQueueOK e a) (EffAMQP e a)

foreign import _checkQueue :: forall e a.
  Fn4 Channel QueueName (ECb e a) (SCb AssertQueueOK e a) (EffAMQP e a)

foreign import _deleteQueue :: forall e a.
  Fn5 Channel QueueName Foreign (ECb e a) (SCb DeleteQueueOK e a) (EffAMQP e a)

foreign import _purgeQueue :: forall e a.
  Fn4 Channel QueueName (ECb e a) (SCb PurgeQueueOK e a) (EffAMQP e a)

foreign import _bindQueue :: forall e a.
  Fn7 Channel QueueName ExchangeName RoutingKey Foreign (ECb e a) (SCb Unit e a) (EffAMQP e a)

foreign import _unbindQueue :: forall e a.
  Fn7 Channel QueueName ExchangeName RoutingKey Foreign (ECb e a) (SCb Unit e a) (EffAMQP e a)

foreign import _assertExchange :: forall e a.
  Fn6 Channel ExchangeName String Foreign (ECb e a) (SCb Unit e a) (EffAMQP e a)

foreign import _checkExchange :: forall e a.
  Fn4 Channel ExchangeName (ECb e a) (SCb Unit e a) (EffAMQP e a)

foreign import _deleteExchange :: forall e a.
  Fn5 Channel ExchangeName Foreign (ECb e a) (SCb Unit e a) (EffAMQP e a)

foreign import _bindExchange :: forall e a.
  Fn7 Channel QueueName QueueName RoutingKey Foreign (ECb e a) (SCb Unit e a) (EffAMQP e a)

foreign import _unbindExchange :: forall e a.
  Fn7 Channel QueueName QueueName RoutingKey Foreign (ECb e a) (SCb Unit e a) (EffAMQP e a)

foreign import _publish :: forall e a.
  Fn6 Channel ExchangeName RoutingKey Buffer Foreign (SCb Unit e a) (EffAMQP e a)

foreign import _sendToQueue :: forall e a.
  Fn5 Channel QueueName Buffer Foreign (SCb Unit e a) (EffAMQP e a)

foreign import _consume :: forall e a.
  Fn6 Channel QueueName (SCb (Nullable Message') e Unit) Foreign (ECb e a) (SCb ConsumeOK e a) (EffAMQP e a)

foreign import _cancel :: forall e a.
  Fn4 Channel String (ECb e a) (SCb Unit e a) (EffAMQP e a)

foreign import _get :: forall e a.
  Fn5 Channel QueueName Foreign (ECb e a) (SCb (Nullable Message') e a) (EffAMQP e a)

foreign import _ack :: forall e a.
  Fn3 Channel String Boolean (EffAMQP e a)

foreign import _nack :: forall e a.
  Fn4 Channel String Boolean Boolean (EffAMQP e a)

foreign import _ackAll :: forall e a.
  Fn1 Channel (EffAMQP e a)

foreign import _nackAll :: forall e a.
  Fn2 Channel Boolean (EffAMQP e a)

foreign import _prefetch :: forall e a.
  Fn2 Channel Int (EffAMQP e a)

foreign import _recover :: forall e a.
  Fn3 Channel (ECb e a) (SCb Unit e a) (EffAMQP e a)

foreign import _onConnectionClose :: forall e a.
  Fn2 Connection (SCb (Nullable Error) e Unit) (EffAMQP e a)

foreign import _onConnectionError :: forall e a.
  Fn2 Connection (SCb Error e Unit) (EffAMQP e a)

foreign import _onConnectionBlocked :: forall e a.
  Fn2 Connection (SCb String e Unit) (EffAMQP e a)

foreign import _onConnectionUnblocked :: forall e a.
  Fn2 Connection (EffAMQP e Unit) (EffAMQP e a)

foreign import _onChannelClose :: forall e a.
  Fn2 Channel (EffAMQP e Unit) (EffAMQP e a)

foreign import _onChannelError :: forall e a.
  Fn2 Channel (SCb Error e Unit) (EffAMQP e a)

foreign import _onChannelReturn :: forall e a.
  Fn2 Channel (SCb Message' e Unit) (EffAMQP e a)

foreign import _onChannelDrain :: forall e a.
  Fn2 Channel (EffAMQP e Unit) (EffAMQP e a)
