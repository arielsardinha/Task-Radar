
import 'package:task_radar/data/services/task_page_sync_service/datasources/remote_todo.dart';

final class RemoteTodosPage {
  final List<RemoteTodo> items;
  final int total;

  const RemoteTodosPage({required this.items, required this.total});
}