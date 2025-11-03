import 'package:equatable/equatable.dart';
import 'package:fake_store_prog/core/models/item.dart';

abstract class ItemViewerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddToCartRequested extends ItemViewerEvent {
  final Item item;

  AddToCartRequested({required this.item});

  @override
  List<Object?> get props => [item];
}
