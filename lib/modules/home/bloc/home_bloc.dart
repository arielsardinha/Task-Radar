import 'package:bloc/bloc.dart';
import 'package:task_radar/data/models/me_model.dart';
import 'package:task_radar/data/repositories/task_repository.dart';
import 'package:task_radar/data/storage/storage_impl.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
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
  }

  Future<void> _onLoadOverview(
    HomeEventLoadOverview event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeStateLoading());

    try {
      final me = (await _storage.getItemToFactory(
        StorageSecureEnum.auth_user,
        fromJson: MeModel.fromJson,
      ))!;

      final counts = await _taskRepository.countByStatus(userId: me.id!);
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
}
