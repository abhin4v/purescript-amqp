var amqp = require('amqplib/callback_api');

var callback = function(onError, onSuccess) {
  return function(err, o) {
    if (err) {
      onError(err)();
      return;
    }
    onSuccess(o)();
  };
};

var callbackOnlyError = function(onError, onSuccess) {
  return function(err) {
    if (err) {
      onError(err)();
      return;
    }
    onSuccess()();
  };
};

exports._connect = function(url, onError,onSuccess) {
  return function() {
    amqp.connect(url, callback(onError, onSuccess));
  };
};

exports._close = function(conn, onError, onSuccess) {
  return function() {
    conn.close(callbackOnlyError(onError, onSuccess));
  };
};

exports._createChannel = function(conn, onError, onSuccess) {
  return function() {
    conn.createChannel(callback(onError, onSuccess));
  };
};

exports._closeChannel = function(channel, onError, onSuccess) {
  return function() {
    channel.close(callbackOnlyError(onError, onSuccess));
  };
};

exports._assertQueue = function(channel, queue, options, onError, onSuccess) {
  return function() {
    channel.assertQueue(queue, options, callback(onError, onSuccess));
  };
};

exports._checkQueue = function(channel, queue, onError, onSuccess) {
  return function() {
    channel.checkQueue(queue, callback(onError, onSuccess));
  };
};

exports._deleteQueue = function(channel, queue, options, onError, onSuccess) {
  return function() {
    channel.deleteQueue(queue, options, callback(onError, onSuccess));
  };
};

exports._purgeQueue = function(channel, queue, onError, onSuccess) {
  return function() {
    channel.purgeQueue(queue, callback(onError, onSuccess));
  };
};

exports._bindQueue = function(channel, queue, exchange, pattern, args, onError, onSuccess) {
  return function() {
    channel.bindQueue(queue, exchange, pattern, args, callbackOnlyError(onError, onSuccess));
  };
};

exports._unbindQueue = function(channel, queue, exchange, pattern, args, onError, onSuccess) {
  return function() {
    channel.unbindQueue(queue, exchange, pattern, args, callbackOnlyError(onError, onSuccess));
  };
};

exports._assertExchange = function(channel, exchange, type, options, onError, onSuccess) {
  return function() {
    channel.assertExchange(exchange, type, options, callbackOnlyError(onError, onSuccess));
  };
};

exports._checkExchange = function(channel, exchange, onError, onSuccess) {
  return function() {
    channel.checkExchange(exchange, callbackOnlyError(onError, onSuccess));
  };
};

exports._deleteExchange = function(channel, exchange, options, onError, onSuccess) {
  return function() {
    channel.deleteExchange(exchange, options, callbackOnlyError(onError, onSuccess));
  };
};

exports._bindExchange = function(channel, destExchange, sourceExchange, pattern, args, onError, onSuccess) {
  return function() {
    channel.bindExchange(destExchange, sourceExchange, pattern, args, callbackOnlyError(onError, onSuccess));
  };
};

exports._unbindExchange = function(channel, destExchange, sourceExchange, pattern, args, onError, onSuccess) {
  return function() {
    channel.unbindExchange(destExchange, sourceExchange, pattern, args, callbackOnlyError(onError, onSuccess));
  };
};

exports._publish = function(channel, exchange, routingKey, content, options, onSuccess) {
  return function() {
    if (!channel.publish(exchange, routingKey, content, options)) {
      channel.once('drain', function() {
        onSuccess()();
      });
    } else {
      onSuccess()();
    }
  }
};

exports._sendToQueue = function(channel, queue, content, options, onSuccess) {
  return function() {
    if (!channel.sendToQueue(queue, content, options)) {
      channel.once('drain', function() {
        onSuccess()();
      });
    } else {
      onSuccess()();
    }
  }
};

exports._consume = function(channel, queue, onMessage, options, onError, onSuccess) {
  return function() {
    channel.consume(queue, function(msg) { onMessage(msg)(); }, options, callback(onError, onSuccess));
  };
};

exports._cancel = function(channel, consumerTag, onError, onSuccess) {
  return function() {
    channel.cancel(consumerTag, callbackOnlyError(onError, onSuccess));
  };
};

exports._get = function(channel, queue, options, onError, onSuccess) {
  return function() {
    channel.get(queue, options, callback(onError, function(msgOrFalse) {
      return function() {
        if (msgOrFalse === false) {
          onSuccess(null)();
        } else {
          onSuccess(msgOrFalse)();
        }
      };
    }))
  };
};

exports._ack = function(channel, deliveryTag, allUpTo) {
  return function() {
    channel.ack({fields: {deliveryTag: deliveryTag}}, allUpTo);
  };
};

exports._nack = function(channel, deliveryTag, allUpTo, requeue) {
  return function() {
    channel.nack({fields: {deliveryTag: deliveryTag}}, allUpTo, requeue);
  };
};

exports._ackAll = function(channel) {
  return function() {
    channel.ackAll();
  };
};

exports._nackAll = function(channel, requeue) {
  return function() {
    channel.nackAll(requeue);
  };
};

exports._prefetch = function(channel, count) {
  return function() {
    channel.prefetch(count);
  };
};

exports._recover = function(channel, onError, onSuccess) {
  return function() {
    channel.recover(callbackOnlyError(onError, onSuccess));
  };
};

var eventHandler = function(event) {
  return function(model, onEvent) {
    return function() {
      model.on(event, function(arg) {
        if (arg === undefined) {
          onEvent();
        } else {
          onEvent(arg)();
        }
      });
    };
  };
};

exports._onConnectionClose = eventHandler('close');
exports._onConnectionError = eventHandler('error');
exports._onConnectionBlocked = eventHandler('blocked');
exports._onConnectionUnblocked = eventHandler('unblocked');

exports._onChannelClose = eventHandler('close');
exports._onChannelError = eventHandler('error');
exports._onChannelReturn = eventHandler('return');
exports._onChannelDrain = eventHandler('drain');
