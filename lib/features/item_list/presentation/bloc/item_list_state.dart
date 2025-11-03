import 'package:equatable/equatable.dart';
import 'package:fake_store_prog/core/models/user.dart';
import 'package:fake_store_prog/core/models/item.dart';

class ItemListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductListStateInitial extends ItemListState {}

class FetchProductsError extends ItemListState {
  final String message;
  FetchProductsError(this.message);

  @override
  List<Object?> get props => [message];
}

class FetchLoading extends ItemListState {}

class OpenProductListSuccess extends ItemListState {
  final List<Item> items;
  final User user;
  final bool hasReachedMax;
  final int page;

  OpenProductListSuccess({
    required this.items,
    required this.user,
    required this.hasReachedMax,
    required this.page,
  });

  OpenProductListSuccess copyWith({
    List<Item>? items,
    User? user,
    bool? hasReachedMax,
    int? page,
  }) {
    return OpenProductListSuccess(
      items: items ?? this.items,
      user: user ?? this.user,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [items, user, hasReachedMax, page];
}
