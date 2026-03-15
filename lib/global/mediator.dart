typedef AsyncCallback<T> = Future<void> Function(T data);

class _Handler<T> {
  final String event;
  final AsyncCallback<T> callback;
  _Handler(this.event, this.callback);
}

class Mediator {
  final List<_Handler> _handlers = [];

  void register<T>(String event, AsyncCallback<T> callback) {
    _handlers.add(_Handler<T>(event, callback));
  }

  Future<T?> notify<T>(String event, [dynamic data]) async {
    for (final h in _handlers) {
      if (h.event == event) {
        await h.callback(data);
      }
    }
    return null;
  }
}
