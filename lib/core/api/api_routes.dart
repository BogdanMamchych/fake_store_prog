class ApiRoutes {
  ApiRoutes._();

  static const String products = '/products';
  static String product(int id) => '/products/$id';

  static const String users = '/users';
  static String user(int id) => '/users/$id';

  static const String authLogin = '/auth/login';

  static const String carts = '/carts';   

  static String withQuery(String url, Map<String, dynamic> query) {
    if (query.isEmpty) return url;
    query.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    return '\$url?\$params';
  }
}
