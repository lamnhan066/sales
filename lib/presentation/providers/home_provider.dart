import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/di.dart';
import 'package:sales/models/views_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeState with EquatableMixin {
  /// Màn hình hiện tại
  final ViewsModel currentView;
  final bool isLoading;

  HomeState({
    required this.currentView,
    required this.isLoading,
  });

  HomeState copyWith({
    ViewsModel? currentView,
    bool? isLoading,
  }) {
    return HomeState(
      currentView: currentView ?? this.currentView,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [currentView, isLoading];
}

class HomeNotifier extends StateNotifier<HomeState> {
  final SharedPreferences _pref;

  HomeNotifier(this._pref) : super(HomeState(currentView: ViewsModel.dashboard, isLoading: true)) {
    _initialize();
  }

  Future<void> _initialize() async {
    final lastView = _pref.getString('LastView');
    state = state.copyWith(
      currentView: lastView == null ? ViewsModel.dashboard : ViewsModel.values.byName(lastView),
      isLoading: false,
    );
  }

  void setView(ViewsModel view) {
    _pref.setString('LastView', view.name);
    state = state.copyWith(currentView: view);
  }

  void logout() {
    _pref.clear();
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(getIt());
});
