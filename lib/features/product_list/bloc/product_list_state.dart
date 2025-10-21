import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:fake_store_prog/features/product_list/models/product.dart';

class ProductListState extends Equatable{
  final UnmodifiableListView<Product> productList;
  final List<String> favoriteList;

  ProductListState({
    List<Product> products = const [],
    this.favoriteList = const [],
  }) : productList = UnmodifiableListView(products);

  @override
  List<Object?> get props => [productList, favoriteList];

}

class ProductListStateInitial extends ProductListState {}

class FetchProductsError extends ProductListState {
  final String message;

  FetchProductsError(this.message);
}

class FetchLoading extends ProductListState {}

class FetchProductsSuccess extends ProductListState {
  FetchProductsSuccess({required super.products});
}