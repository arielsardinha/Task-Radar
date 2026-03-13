

final class RequestAdapter{
  final String path;
  final dynamic data;
  final Map<String, dynamic>? queryParams;
  final Map<String, dynamic>? headers;

  const RequestAdapter({
    required this.path,
    this.data,
    this.queryParams,
    this.headers,
  });
}
