class ResultPage {
  Map<String, dynamic> data;
  int pageItemsCount;
  int totalItemsCount;
  int page;
  int maxPage;

  ResultPage({
    required this.data,
    required this.pageItemsCount,
    required this.totalItemsCount,
    required this.page,
    required this.maxPage,
  });

  ResultPage.empty({
    this.data = const {},
    this.pageItemsCount = 0,
    this.totalItemsCount = 0,
    this.page = 0,
    this.maxPage = 0,
  });
}
