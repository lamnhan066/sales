abstract interface class PageConfigurationsRepository {
  Future<int> getItemPerPage();
  Future<void> setItemPerPage(int value);
}
