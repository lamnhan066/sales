import 'package:sales/domain/entities/views_model.dart';
import 'package:sales/domain/repositories/last_view_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastViewRepositoryImpl implements LastViewRepository {
  final SharedPreferences _prefs;

  const LastViewRepositoryImpl(this._prefs);

  @override
  Future<ViewsModel> getLastView() async {
    final viewPref = _prefs.getString('LastViewRepository.LastView');
    if (viewPref == null) {
      return ViewsModel.dashboard;
    }
    return ViewsModel.values.byName(viewPref);
  }

  @override
  Future<bool> getSaveLastViewState() async {
    return _prefs.getBool('LastViewRepository.SaveLastView') ?? true;
  }

  @override
  Future<void> setLastView(ViewsModel view) async {
    await _prefs.setString('LastViewRepository.LastView', view.name);
  }

  @override
  Future<void> setSaveLastViewState(bool save) async {
    await _prefs.setBool('LastViewRepository.SaveLastView', save);
  }
}
