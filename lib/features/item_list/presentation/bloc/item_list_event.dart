abstract class ItemListEvent {}

class FetchItemsEvent extends ItemListEvent {
  final bool refresh;
  FetchItemsEvent({this.refresh = false});
}
