import 'package:sales/domain/entities/views_model.dart';

abstract class LastViewRepository {
  Future<bool> getSaveLastViewState();
  Future<void> setSaveLastViewState(bool save);
  Future<ViewsModel> getLastView();
  Future<void> setLastView(ViewsModel view);
}
