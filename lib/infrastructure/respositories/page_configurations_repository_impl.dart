import 'package:sales/domain/repositories/page_configurations_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageConfigurationsRepositoryImpl implements PageConfigurationsRepository {

  const PageConfigurationsRepositoryImpl(this._prefs);
  final SharedPreferences _prefs;

  @override
  Future<int> getItemPerPage() async {
    return _prefs.getInt('ItemPerPage') ?? 10;
  }

  @override
  Future<void> setItemPerPage(int value) async {
    await _prefs.setInt('ItemPerPage', value);
  }
}
