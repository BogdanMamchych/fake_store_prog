import 'package:equatable/equatable.dart';
import 'package:fake_store_prog/core/models/user.dart';
import 'package:fake_store_prog/core/models/item.dart';

class ItemListState extends Equatable{

  @override
  List<Object?> get props => [];

}

class ProductListStateInitial extends ItemListState {}

class FetchProductsError extends ItemListState {
  final String message;

  FetchProductsError(this.message);
}

class FetchLoading extends ItemListState {}

class OpenProductListSuccess extends ItemListState {
  final List<Item> items;
  final User user;

  OpenProductListSuccess({required this.items, required this.user});
}