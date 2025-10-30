import 'package:equatable/equatable.dart';
import 'package:fake_store_prog/core/models/item.dart';

abstract class ProductViewerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProductEvent extends ProductViewerEvent {
  final int productId;

  GetProductEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class AddToCart extends ProductViewerEvent {
  final Item product;

  AddToCart({required this.product});

  @override
  List<Object?> get props => [product];
}
