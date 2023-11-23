abstract class PageViewState {}

class PageViewInitial extends PageViewState {}

class PageViewLoadInProgress extends PageViewState {}

class PageViewLoadSuccess extends PageViewState {
  final int currentPageIndex;

  PageViewLoadSuccess({required this.currentPageIndex});
}

class PageViewLoadFailure extends PageViewState {
  final String error;

  PageViewLoadFailure({required this.error});
}
