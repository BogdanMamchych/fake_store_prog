import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'api_routes.dart';

@LazySingleton()
class ApiClient {
  final Dio dio;

  ApiClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://fakestoreapi.com',
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
            contentType: 'application/json',
          ),
        )..interceptors.add(
            LogInterceptor(
              requestBody: true,
              responseBody: true,
            ),
          );

  Future<Response> fetchProducts({Map<String, dynamic>? queryParameters}) async {
    return await dio.get(ApiRoutes.products, queryParameters: queryParameters);
  }

  Future<Response> login(String login, String password) async {
    return await dio.post(ApiRoutes.authLogin, 
      data: {
        'username': login,
        'password': password,
      },
    );
  }

  Future<Response> getUserById(int id) async {
    return await dio.get(ApiRoutes.user(id));
  }

  Future<Response> getProductById(int id) async {
    return await dio.get(ApiRoutes.product(id));
  }

}
