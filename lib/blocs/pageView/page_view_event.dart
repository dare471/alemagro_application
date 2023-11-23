abstract class PageViewEvent {}

class PageChanged extends PageViewEvent {
  final int pageIndex;

  PageChanged({required this.pageIndex});
}

class NavigateToPage extends PageViewEvent {
  final int pageIndex;

  NavigateToPage({required this.pageIndex});
}
