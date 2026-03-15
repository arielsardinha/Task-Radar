import 'package:bloc/bloc.dart';
import 'package:task_radar/data/repositories/task_repository.dart';
import 'package:task_radar/data/storage/storage_impl.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import 'package:task_radar/domain/user.dart';
import 'package:task_radar/modules/home/bloc/home_event.dart';
import 'package:task_radar/modules/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TaskRepository _taskRepository;
  final StorageImpl _storage;

  HomeBloc({
    required TaskRepository taskRepository,
    required StorageImpl storage,
  }) : _taskRepository = taskRepository,
       _storage = storage,
       super(const HomeStateInitial()) {
    on<HomeEventLoadOverview>(_onLoadOverview);
    on<HomeEventCreateTask>(_onCreateTask);
  }

  Future<void> _onLoadOverview(
    HomeEventLoadOverview event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeStateLoading());

    try {
      final me = (await _storage.getItemToFactory(
        StorageSecureEnum.auth_user,
        fromJson: User.fromStorageJson,
      ))!;

      final counts = await _taskRepository.countByStatus(userId: me.id);
      emit(
        HomeStateOverviewLoaded(
          pending: counts.pending,
          completed: counts.completed,
        ),
      );
    } catch (_) {
      emit(
        const HomeStateFailure(
          message: 'Falha ao carregar o resumo de tarefas.',
        ),
      );
    }
  }

  Future<void> _onCreateTask(
    HomeEventCreateTask event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final me = (await _storage.getItemToFactory(
        StorageSecureEnum.auth_user,
        fromJson: User.fromStorageJson,
      ))!;

      await _taskRepository.create(
        userId: me.id,
        name: event.name,
        description: event.description,
      );

      add(HomeEventLoadOverview());
    } catch (_) {
      emit(const HomeStateFailure(message: 'Falha ao criar tarefa.'));
    }
  }
}
