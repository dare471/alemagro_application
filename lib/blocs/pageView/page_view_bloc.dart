import 'package:flutter_bloc/flutter_bloc.dart';

import 'page_view_event.dart';
import 'page_view_state.dart';

class PageViewBloc extends Bloc<PageViewEvent, PageViewState> {
  PageViewBloc() : super(PageViewInitial());

  @override
  Stream<PageViewState> mapEventToState(
    PageViewEvent event,
  ) async* {
    if (event is PageChanged) {
      // Обработка события изменения страницы
      yield PageViewLoadSuccess(currentPageIndex: event.pageIndex);
    } else if (event is NavigateToPage) {
      // Обработка события навигации на страницу
      yield PageViewLoadInProgress();
      await _navigateToPage(event.pageIndex);
      yield PageViewLoadSuccess(currentPageIndex: event.pageIndex);
    }
    // Другие обработчики событий...
  }

  Future<void> _navigateToPage(int pageIndex) async {
    // Логика навигации
    // Например, можно использовать PageController для анимированного перехода на страницу
  }
}
