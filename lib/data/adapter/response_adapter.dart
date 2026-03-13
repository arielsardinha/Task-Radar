final class ResponseAdapter<T> {
  final T? data;
  final int? statusCode;
  final String? statusMessage;
  final String? type;

  const ResponseAdapter({this.data, this.statusCode, this.statusMessage, this.type});
}
