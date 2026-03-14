import 'package:bloc/bloc.dart';
import 'package:task_radar/data/models/me_model.dart';
import 'package:task_radar/data/repositories/task_repository.dart';
import 'package:task_radar/data/storage/storage_impl.dart';
import 'package:task_radar/data/storage/storage_secure_enum.dart';
import 'package:task_radar/domain/task.dart';
import 'package:task_radar/modules/tasks/bloc/tasks_event.dart';
import 'package:task_radar/modules/tasks/bloc/tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TaskRepository _taskRepository;
  final StorageImpl _storage;

  TasksBloc({
    required TaskRepository taskRepository,
    required StorageImpl storage,
  }) : _taskRepository = taskRepository,
       _storage = storage,
       super(const TasksState.initial()) {
    on<TasksEventLoad>(_onLoad);
    on<TasksEventSearchChanged>(_onSearchChanged);
    on<TasksEventFilterChanged>(_onFilterChanged);
    on<TasksEventOrderChanged>(_onOrderChanged);
    on<TasksEventOrderDirectionChanged>(_onOrderDirectionChanged);
    on<TasksEventToggleCompleted>(_onToggleCompleted);
    on<TasksEventUpdateTask>(_onUpdateTask);
    on<TasksEventDeleteTask>(_onDeleteTask);
    on<TasksEventCreateTask>(_onCreateTask);
  }

  Future<void> _onLoad(TasksEventLoad event, Emitter<TasksState> emit) async {
    emit(state.copyWith(status: TasksStateStatus.loading, clearMessage: true));

    try {
      final me = (await _storage.getItemToFactory(
        StorageSecureEnum.auth_user,
        fromJson: MeModel.fromJson,
      ))!;

      final userId = me.id;
      if (userId == null) {
        emit(
          state.copyWith(
            status: TasksStateStatus.failure,
            message: 'Nao foi possivel identificar o usuario autenticado.',
          ),
        );
        return;
      }

      final tasks = await _taskRepository.getAllByUser(userId: userId);
      final visible = _applyView(
        tasks: tasks,
        query: state.query,
        filter: state.filter,
        order: state.order,
        orderAscending: state.orderAscending,
      );

      emit(
        state.copyWith(
          status: TasksStateStatus.success,
          allTasks: tasks,
          visibleTasks: visible,
          clearMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: TasksStateStatus.failure,
          message: 'Falha ao carregar tarefas.',
        ),
      );
    }
  }

  void _onSearchChanged(
    TasksEventSearchChanged event,
    Emitter<TasksState> emit,
  ) {
    final visible = _applyView(
      tasks: state.allTasks,
      query: event.query,
      filter: state.filter,
      order: state.order,
      orderAscending: state.orderAscending,
    );

    emit(
      state.copyWith(
        status: TasksStateStatus.success,
        visibleTasks: visible,
        query: event.query,
        clearMessage: true,
      ),
    );
  }

  void _onFilterChanged(
    TasksEventFilterChanged event,
    Emitter<TasksState> emit,
  ) {
    final visible = _applyView(
      tasks: state.allTasks,
      query: state.query,
      filter: event.filter,
      order: state.order,
      orderAscending: state.orderAscending,
    );

    emit(
      state.copyWith(
        status: TasksStateStatus.success,
        visibleTasks: visible,
        filter: event.filter,
        clearMessage: true,
      ),
    );
  }

  void _onOrderChanged(TasksEventOrderChanged event, Emitter<TasksState> emit) {
    final visible = _applyView(
      tasks: state.allTasks,
      query: state.query,
      filter: state.filter,
      order: event.order,
      orderAscending: state.orderAscending,
    );

    emit(
      state.copyWith(
        status: TasksStateStatus.success,
        visibleTasks: visible,
        order: event.order,
        clearMessage: true,
      ),
    );
  }

  void _onOrderDirectionChanged(
    TasksEventOrderDirectionChanged event,
    Emitter<TasksState> emit,
  ) {
    final visible = _applyView(
      tasks: state.allTasks,
      query: state.query,
      filter: state.filter,
      order: state.order,
      orderAscending: event.ascending,
    );

    emit(
      state.copyWith(
        status: TasksStateStatus.success,
        visibleTasks: visible,
        orderAscending: event.ascending,
        clearMessage: true,
      ),
    );
  }

  Future<void> _onToggleCompleted(
    TasksEventToggleCompleted event,
    Emitter<TasksState> emit,
  ) async {
    try {
      await _taskRepository.toggleCompleted(event.task);
      add(TasksEventLoad());
    } catch (_) {
      emit(
        state.copyWith(
          status: TasksStateStatus.failure,
          message: 'Falha ao atualizar status da tarefa.',
        ),
      );
    }
  }

  Future<void> _onUpdateTask(
    TasksEventUpdateTask event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final updatedTask = event.task.copyWith(
        name: event.name,
        description: event.description,
        updatedAt: DateTime.now(),
      );

      await _taskRepository.updateTask(updatedTask);
      add(TasksEventLoad());
    } catch (_) {
      emit(
        state.copyWith(
          status: TasksStateStatus.failure,
          message: 'Falha ao atualizar tarefa.',
        ),
      );
    }
  }

  Future<void> _onDeleteTask(
    TasksEventDeleteTask event,
    Emitter<TasksState> emit,
  ) async {
    try {
      await _taskRepository.delete(event.task);
      add(TasksEventLoad());
    } catch (_) {
      emit(
        state.copyWith(
          status: TasksStateStatus.failure,
          message: 'Falha ao excluir tarefa.',
        ),
      );
    }
  }

  Future<void> _onCreateTask(
    TasksEventCreateTask event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final me = (await _storage.getItemToFactory(
        StorageSecureEnum.auth_user,
        fromJson: MeModel.fromJson,
      ))!;

      final userId = me.id;
      if (userId == null) {
        emit(
          state.copyWith(
            status: TasksStateStatus.failure,
            message: 'Nao foi possivel identificar o usuario autenticado.',
          ),
        );
        return;
      }

      await _taskRepository.create(
        userId: userId,
        name: event.name,
        description: event.description,
      );

      add(TasksEventLoad());
    } catch (_) {
      emit(
        state.copyWith(
          status: TasksStateStatus.failure,
          message: 'Falha ao criar tarefa.',
        ),
      );
    }
  }

  List<Task> _applyView({
    required List<Task> tasks,
    required String query,
    required TaskListFilter filter,
    required TaskListOrder order,
    required bool orderAscending,
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    var filtered = tasks.where((task) {
      final byFilter = switch (filter) {
        TaskListFilter.all => true,
        TaskListFilter.pending => task.status == TaskStatus.pending,
        TaskListFilter.completed => task.status == TaskStatus.completed,
      };

      if (!byFilter) {
        return false;
      }

      if (normalizedQuery.isEmpty) {
        return true;
      }

      return task.description.toLowerCase().contains(normalizedQuery);
    }).toList();

    filtered.sort((a, b) {
      final compare = switch (order) {
        TaskListOrder.defaultById => (a.remoteId ?? 1 << 30).compareTo(
          b.remoteId ?? 1 << 30,
        ),
        TaskListOrder.alphabetical => a.name.toLowerCase().compareTo(
          b.name.toLowerCase(),
        ),
        TaskListOrder.completionStatus => a.status.name.compareTo(
          b.status.name,
        ),
      };

      return orderAscending ? compare : -compare;
    });

    return filtered;
  }
}
