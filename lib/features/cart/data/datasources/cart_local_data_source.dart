import 'package:fake_store_prog/core/local/user_preferences.dart';
import 'package:fake_store_prog/core/models/cart_item.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/local/exceptions.dart';
import 'package:synchronized/synchronized.dart';
import 'package:fake_store_prog/core/helpers/find_cart_item.dart';

@lazySingleton
class CartLocalDataSource {
  final UserPreferences _userPreferences;
  final Lock _lock = Lock();

  CartLocalDataSource(this._userPreferences);

  Future<List<CartItem>> getCartList() async {
    return await _lock.synchronized(() async {
      try {
        final list = _userPreferences.getCartList();
        return Future.value(list);
      } on FormatException catch (fe) {
        throw ParsingException(fe.message);
      } on Exception catch (e) {
        throw StorageException(e.toString());
      }
    });
  }

  Future<void> setCartList(List<CartItem> list) async {
    return await _lock.synchronized(() {
      try {
        _userPreferences.setCartList(list);
      } on Exception catch (e) {
        throw StorageException(e.toString());
      }
    });
  }

  Future<void> addItem(CartItem item) async {
    await _lock.synchronized(() async {
      try {
        final list = _userPreferences.getCartList();
        final (existingItem, wasFound) = findCartItem(list, item);
        if (wasFound && existingItem != null) {
          existingItem.quantity += 1;
        } else {
          list.add(item);
        }
        await _userPreferences.setCartList(list);
      } on FormatException catch (fe) {
        throw ParsingException(fe.message);
      } on Exception catch (e) {
        throw StorageException(e.toString());
      }
    });
  }

  Future<void> removeItem(CartItem item) async {
    await _lock.synchronized(() async {
      try {
        final list = _userPreferences.getCartList();
        list.removeWhere((cartItem) => cartItem.itemId == item.itemId);
        await _userPreferences.setCartList(list);
      } on Exception catch (e) {
        throw StorageException(e.toString());
      }
    });
  }

  Future<void> increaseQuantity(CartItem item) async {
    await _lock.synchronized(() async {
      try {
        final List<CartItem> list = _userPreferences.getCartList();

        final idx = list.indexWhere((ci) => ci.itemId == item.itemId);
        list[idx].quantity = list[idx].quantity + 1;
        if (idx == -1) {
          throw ItemNotFoundException('Item ${item.itemId} not found');
        }
        await _userPreferences.setCartList(list);
      } on FormatException catch (fe) {
        throw ParsingException(fe.message);
      } on Exception catch (e) {
        throw StorageException(e.toString());
      }
    });
  }

  Future<void> decreaseQuantity(CartItem item) async {
    await _lock.synchronized(() async {
      try {
        final list = _userPreferences.getCartList();
        final idx = list.indexWhere((ci) => ci.itemId == item.itemId);
        if (idx == -1) throw ItemNotFoundException('Item ${item.itemId} not found');

        if (list[idx].quantity <= 1) {
          list.removeAt(idx);
        } else {
          list[idx].quantity = list[idx].quantity - 1;
        }
        await _userPreferences.setCartList(list);
      } on FormatException catch (fe) {
        throw ParsingException(fe.message);
      } on Exception catch (e) {
        throw StorageException(e.toString());
      }
    });
  }

  Future<void> clearCartList() async {
    await _lock.synchronized(() async {
      try {
        await _userPreferences.clearCartList();
      } on Exception catch (e) {
        throw StorageException(e.toString());
      }
    });
  }
}
