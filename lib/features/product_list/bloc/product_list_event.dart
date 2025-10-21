abstract class ProductListEvent {}

class FetchProductsEvent extends ProductListEvent {}

class AddToFavoritesEvent extends ProductListEvent {
  final String productId;

  AddToFavoritesEvent(this.productId);
}

class RemoveFromFavoritesEvent extends ProductListEvent {
  final String productId;

  RemoveFromFavoritesEvent(this.productId);
}

class AddToCartEvent extends ProductListEvent {
  final String productId;

  AddToCartEvent(this.productId);
}