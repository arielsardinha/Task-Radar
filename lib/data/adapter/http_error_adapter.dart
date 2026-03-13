import 'package:task_radar/data/adapter/request_adapter.dart';
import 'package:task_radar/data/adapter/response_adapter.dart';

class HttpError implements Exception {
  final ResponseAdapter response;
  final RequestAdapter? request;
  final dynamic exception;
  final StackTrace? stackTrace;
  final String? statusMessage;

  const HttpError({
    required this.response,
    this.request,
    this.exception,
    this.stackTrace,
    this.statusMessage,
  });
}
