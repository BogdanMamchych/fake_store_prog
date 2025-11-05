class ApiRoutes {
  ApiRoutes._();

  static const String items = '/products';
  static String item(int id) => '/products/$id';

  static const String users = '/users';
  static String user(int id) => '/users/$id';

  static const String authLogin = '/auth/login';

  static const String carts = '/carts';   
}
