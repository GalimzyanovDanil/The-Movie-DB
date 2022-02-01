class PaginatorLoadResult<T> {
  final int? currentPage;
  final int? totalPage;
  final List<T>? data;

  PaginatorLoadResult({
    required this.currentPage,
    required this.totalPage,
    required this.data,
  });
}

typedef PaginatorLoader<T> = Future<PaginatorLoadResult<T>> Function(int);

class Paginator<T> {
  final PaginatorLoader<T> loader;
  final _data = <T>[];
  bool loadingIsProgress = false;
  int _currentPage = 0;
  int _totalPage = 1;
  int nextPage = 0;

  List<T> get data => _data;

  Paginator({required this.loader});

  Future<void> loadNextPage() async {
    if (loadingIsProgress || _currentPage >= _totalPage) return;
    loadingIsProgress = true;
    nextPage = _currentPage + 1;
    try {
      final result = await loader(nextPage);

      _currentPage = result.currentPage ?? 0;
      _totalPage = result.totalPage ?? 1;
      _data.addAll(result.data ?? []);
      loadingIsProgress = false;
      
    } catch (_) {
      loadingIsProgress = false;
    }
  }

  Future<void> reset() async {
    _data.clear();
    _currentPage = 0;
    _totalPage = 1;
    // await loadNextPage();
  }
}
