import 'dart:async';

// É essencialmente um stream, mas:
// 1. armazenamos em cache o lastValue do stream
// 2. o "latestValue" é reemitido sempre que o stream é ouvido
class StreamControllerReemit<T> {
  T? _latestValue;

  final StreamController<T> _controller = StreamController<T>.broadcast();

  StreamControllerReemit({T? initialValue}) : _latestValue = initialValue;

  Stream<T> get stream {
    // ignore: null_check_on_nullable_type_parameter
    return _latestValue != null ? _controller.stream.newStreamWithInitialValue(_latestValue!) : _controller.stream;
  }

  T? get value => _latestValue;

  void add(T newValue) {
    _latestValue = newValue;
    _controller.add(newValue);
  }

  Future<void> close() {
    return _controller.close();
  }
}

// retorna um novo stream que emite imediatamente um valor inicial
extension _StreamNewStreamWithInitialValue<T> on Stream<T> {
  Stream<T> newStreamWithInitialValue(T initialValue) {
    return transform(_NewStreamWithInitialValueTransformer(initialValue));
  }
}

// Auxiliar do método 'newStreamWithInitialValue' para streams.
class _NewStreamWithInitialValueTransformer<T> extends StreamTransformerBase<T, T> {
  /// o valor inicial a ser enviado para o novo stream
  final T initialValue;

  /// controlador para o novo stream
  late StreamController<T> controller;

  /// assinatura do stream original
  late StreamSubscription<T> subscription;

  /// nova contagem de ouvintes de stream
  var listenerCount = 0;

  _NewStreamWithInitialValueTransformer(this.initialValue);

  @override
  Stream<T> bind(Stream<T> stream) {
    if (stream.isBroadcast) {
      return _bind(stream, broadcast: true);
    } else {
      return _bind(stream);
    }
  }

  Stream<T> _bind(Stream<T> stream, {bool broadcast = false}) {

    /////////////////////////////////////////
    /// Original Stream Subscription Callbacks
    /// 

    /// When the original stream emits data, forward it to our new stream
    void onData(T data) {
      controller.add(data);
    }

    /// When the original stream is done, close our new stream
    void onDone() {
      controller.close();
    }

    /// When the original stream has an error, forward it to our new stream
    void onError(Object error) {
      controller.addError(error);
    }

    /// When a client listens to our new stream, emit the
    /// initial value and subscribe to original stream if needed
    void onListen() {
      // Emit the initial value to our new stream
      controller.add(initialValue);

      // listen to the original stream, if needed
      if (listenerCount == 0) {
        subscription = stream.listen(
          onData,
          onError: onError,
          onDone: onDone,
        );
      }

      // count listeners of the new stream
      listenerCount++;
    }

    //////////////////////////////////////
    ///  New Stream Controller Callbacks
    /// 

    /// (Single Subscription Only) When a client pauses
    /// the new stream, pause the original stream 
    void onPause() {
      subscription.pause();
    }

    /// (Single Subscription Only) When a client resumes
    /// the new stream, resume the original stream 
    void onResume() {
      subscription.resume();
    }

    /// Called when a client cancels their 
    /// subscription to the new stream, 
    void onCancel() {
      // count listeners of the new stream
      listenerCount--;

      // when there are no more listeners of the new stream,
      // cancel the subscription to the original stream,
      // and close the new stream controller
      if (listenerCount == 0) {
        subscription.cancel();
        controller.close();
      }
    }

    //////////////////////////////////////
    /// Return New Stream
    /// 

    // create a new stream controller
    if (broadcast) {
      controller = StreamController<T>.broadcast(
        onListen: onListen,
        onCancel: onCancel,
      );
    } else {
      controller = StreamController<T>(
        onListen: onListen,
        onPause: onPause,
        onResume: onResume,
        onCancel: onCancel,
      );
    }

    return controller.stream;
  }
}
