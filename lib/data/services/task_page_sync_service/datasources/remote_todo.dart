final class RemoteTodo {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  const RemoteTodo({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory RemoteTodo.fromJson(Map<String, dynamic> json) {
    return RemoteTodo(
      id: (json['id'] as num).toInt(),
      todo: (json['todo'] as String?)?.trim() ?? '',
      completed: json['completed'] == true,
      userId: (json['userId'] as num).toInt(),
    );
  }
}
