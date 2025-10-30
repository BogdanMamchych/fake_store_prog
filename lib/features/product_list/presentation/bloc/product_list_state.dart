import 'package:equatable/equatable.dart';
import 'package:fake_store_prog/core/models/user.dart';
import 'package:fake_store_prog/core/models/item.dart';

class ProductListState extends Equatable{

  @override
  List<Object?> get props => [];

}

class ProductListStateInitial extends ProductListState {}

class FetchProductsError extends ProductListState {
  final String message;

  FetchProductsError(this.message);
}

class FetchLoading extends ProductListState {}

class OpenProductListSuccess extends ProductListState {
  final List<Item> products;
  final User user;

  OpenProductListSuccess({required this.products, required this.user});
}