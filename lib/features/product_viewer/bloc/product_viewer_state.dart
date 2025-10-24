import 'package:equatable/equatable.dart';
import 'package:fake_store_prog/features/product_list/domain/entities/product.dart';

class ProductViewerState extends Equatable{
  @override
  List<Object?> get props => [];
}

class ProductViewerInitial extends ProductViewerState {}

class ProductViewerLoading extends ProductViewerState {}

class ProductViewerLoaded extends ProductViewerState {
  final Product productData;

  ProductViewerLoaded({required this.productData});

  @override
  List<Object?> get props => [productData];
}

class ProductViewerError extends ProductViewerState {
  final String message;

  ProductViewerError({required this.message});

  @override
  List<Object?> get props => [message];
}