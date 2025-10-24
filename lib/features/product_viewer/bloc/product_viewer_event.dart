import 'package:equatable/equatable.dart';
import 'package:fake_store_prog/features/product_list/domain/entities/product.dart';

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
  final Product product;

  AddToCart({required this.product});

  @override
  List<Object?> get props => [product];
}
