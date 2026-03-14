abstract class HomeState {
  const HomeState();
}

final class HomeStateInitial extends HomeState {
  const HomeStateInitial();
}

final class HomeStateLoading extends HomeState {
  const HomeStateLoading();
}

final class HomeStateFailure extends HomeState {
  final String message;

  const HomeStateFailure({required this.message});
}

final class HomeStateOverviewLoaded extends HomeState {
  final int pending;
  final int completed;

  const HomeStateOverviewLoaded({
    required this.pending,
    required this.completed,
  });

  int get total => pending + completed;
}
