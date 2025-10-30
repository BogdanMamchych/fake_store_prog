import 'package:equatable/equatable.dart';
import 'package:fake_store_prog/core/models/item.dart';

class ProductViewerState extends Equatable{
  @override
  List<Object?> get props => [];
}

class ProductViewerInitial extends ProductViewerState {}

class ProductViewerLoading extends ProductViewerState {}

class ProductViewerLoaded extends ProductViewerState {
  final Item productData;

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