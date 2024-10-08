abstract class Pagination {
  Future<void> goToPage(int page);
  Future<void> goToPreviousPage();
  Future<void> goToNextPage();
}
