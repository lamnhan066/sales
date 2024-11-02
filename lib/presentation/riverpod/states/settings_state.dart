import 'package:equatable/equatable.dart';

class SettingsState with EquatableMixin {
  final int itemPerPage;
  final bool saveLastView;
  final String backupRestoreStatus;
  final String error;
  final bool isLoading;

  SettingsState({
    this.itemPerPage = 10,
    this.saveLastView = true,
    this.backupRestoreStatus = '',
    this.error = '',
    this.isLoading = false,
  });

  SettingsState copyWith({
    int? itemPerPage,
    bool? saveLastView,
    String? backupRestoreStatus,
    String? error,
    bool? isLoading,
  }) {
    return SettingsState(
      itemPerPage: itemPerPage ?? this.itemPerPage,
      saveLastView: saveLastView ?? this.saveLastView,
      backupRestoreStatus: backupRestoreStatus ?? this.backupRestoreStatus,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props {
    return [
      itemPerPage,
      saveLastView,
      backupRestoreStatus,
      error,
      isLoading,
    ];
  }
}
