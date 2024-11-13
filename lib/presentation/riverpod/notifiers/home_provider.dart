import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/views_model.dart';
import 'package:sales/domain/usecases/auth/logout_usecase.dart';
import 'package:sales/domain/usecases/last_view/get_last_view_usecase.dart';
import 'package:sales/domain/usecases/last_view/get_save_last_view_usecase.dart';
import 'package:sales/domain/usecases/last_view/set_last_view_usecase.dart';
import 'package:sales/presentation/riverpod/states/home_state.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(
    logoutUseCase: getIt(),
    getSaveLastViewUsecase: getIt(),
    getLastViewUseCase: getIt(),
    setLastViewUseCase: getIt(),
  );
});

class HomeNotifier extends StateNotifier<HomeState> {

  HomeNotifier({
    required GetSaveLastViewUsecase getSaveLastViewUsecase,
    required GetLastViewUseCase getLastViewUseCase,
    required SetLastViewUseCase setLastViewUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _getLastViewUseCase = getLastViewUseCase,
        _getSaveLastViewUsecase = getSaveLastViewUsecase,
        _setLastViewUseCase = setLastViewUseCase,
        _logoutUseCase = logoutUseCase,
        super(HomeState(currentView: ViewsModel.dashboard, isLoading: true)) {
    _initialize();
  }
  final GetSaveLastViewUsecase _getSaveLastViewUsecase;
  final GetLastViewUseCase _getLastViewUseCase;
  final SetLastViewUseCase _setLastViewUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> _initialize() async {
    if (await _getSaveLastViewUsecase(NoParams())) {
      final lastView = await _getLastViewUseCase(NoParams());
      state = state.copyWith(
        currentView: lastView,
        isLoading: false,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> setView(ViewsModel view) async {
    state = state.copyWith(currentView: view);
    await _setLastViewUseCase(view);
  }

  Future<void> logout() async {
    await _logoutUseCase(NoParams());
  }
}
