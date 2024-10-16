import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/views_model.dart';
import 'package:sales/domain/usecases/auth/logout_usecase.dart';
import 'package:sales/presentation/riverpod/states/home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(prefs: getIt(), logoutUseCase: getIt());
});

class HomeNotifier extends StateNotifier<HomeState> {
  final SharedPreferences _prefs;
  final LogoutUseCase _logoutUseCase;

  HomeNotifier({
    required SharedPreferences prefs,
    required LogoutUseCase logoutUseCase,
  })  : _prefs = prefs,
        _logoutUseCase = logoutUseCase,
        super(HomeState(currentView: ViewsModel.dashboard, isLoading: true)) {
    _initialize();
  }

  Future<void> _initialize() async {
    final lastView = _prefs.getString('LastView');
    state = state.copyWith(
      currentView: lastView == null ? ViewsModel.dashboard : ViewsModel.values.byName(lastView),
      isLoading: false,
    );
  }

  void setView(ViewsModel view) {
    _prefs.setString('LastView', view.name);
    state = state.copyWith(currentView: view);
  }

  void logout() {
    _logoutUseCase(NoParams());
  }
}
