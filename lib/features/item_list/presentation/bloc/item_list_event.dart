import 'package:equatable/equatable.dart';

abstract class ItemListEvent extends Equatable{}

class FetchItemsRequested extends ItemListEvent {
  final bool refresh;
  FetchItemsRequested({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}
