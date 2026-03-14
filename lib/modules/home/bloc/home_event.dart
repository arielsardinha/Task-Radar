abstract class HomeEvent {}

final class HomeEventLoadOverview extends HomeEvent {}

final class HomeEventCreateTask extends HomeEvent {
  final String name;
  final String description;

  HomeEventCreateTask({required this.name, required this.description});
}
