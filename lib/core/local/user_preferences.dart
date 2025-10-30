import 'dart:convert';

import 'package:fake_store_prog/core/models/user.dart';
import 'package:fake_store_prog/core/models/cart_item.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton()
class UserPreferences {
  late SharedPreferences prefs;
  static const _userIdKey = 'userId';
  static const _usernameKey = 'username';
  static const _emailKey = 'email';
  static const _cartList = 'cartList';

  UserPreferences() {
    init();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> setUser(User user) async {
    await prefs.setInt(_userIdKey, user.id);
    await prefs.setString(_usernameKey, user.name);
    await prefs.setString(_emailKey, user.email);
  }

  User? getUser() {
    final id = prefs.getInt(_userIdKey);
    final name = prefs.getString(_usernameKey);
    final email = prefs.getString(_emailKey);

    if (id != null && name != null && email != null) {
      return User(id: id, name: name, email: email);
    }
    return null;
  }

  Future<void> clearUser() async {
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_emailKey);
  }

  Future<void> setCartList(List<CartItem> cartList) async {
    final List<Map<String, dynamic>> cartJsonList = cartList.map((item) => item.toJson()).toList();
    final String jsonString = json.encode(cartJsonList);
    await prefs.setString(_cartList, jsonString);
  }

  List<CartItem> getCartList() {
    final String? jsonString = prefs.getString(_cartList);
    if (jsonString != null) {
      final List<dynamic> cartJsonList = json.decode(jsonString);
      return cartJsonList.map((item) => CartItem.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> clearCartList() async {
    await prefs.remove(_cartList);
  }
}