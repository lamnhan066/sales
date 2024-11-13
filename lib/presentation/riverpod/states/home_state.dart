import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/views_model.dart';

class HomeState with EquatableMixin {

  HomeState({
    required this.currentView,
    required this.isLoading,
  });
  /// Màn hình hiện tại
  final ViewsModel currentView;
  final bool isLoading;

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
