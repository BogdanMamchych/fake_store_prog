import 'package:equatable/equatable.dart';
import 'package:fake_store_prog/core/models/item.dart';

abstract class ProductViewerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends ProductViewerEvent {
  final Item product;

  AddToCartEvent({required this.product});

  @override
  List<Object?> get props => [product];
}
