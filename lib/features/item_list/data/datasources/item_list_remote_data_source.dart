import 'package:dio/dio.dart';
import 'package:fake_store_prog/core/api/api_client.dart';
import 'package:fake_store_prog/core/local/user_preferences.dart';
import 'package:fake_store_prog/core/models/user.dart';
import 'package:fake_store_prog/core/models/item.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/local/exceptions.dart';

@lazySingleton
class ItemListRemoteDataSource {
  final ApiClient _apiClient;
  final UserPreferences _userPreferences;
  ItemListRemoteDataSource(this._apiClient, this._userPreferences);

  Future<List<Item>> fetchItems() async {
    try {
      final response = await _apiClient.fetchItems();

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        try {
          final items = data.map((json) => Item.fromJson(json)).toList();
          return items;
        } on FormatException catch (fe) {
          throw ParsingException(fe.message);
        } on TypeError catch (te) {
          throw ParsingException(te.toString());
        }
      }

      final status = response.statusCode;
      if (status != null && status >= 500) {
        throw ServerException(status, 'Server error: $status');
      } else if (status == 401) {
        throw UnauthorizedException('Unauthorized');
      } else if (status == 404) {
        throw NotFoundException('Items not found');
      } else {
        throw NetworkException('Unexpected HTTP status ${status ?? 'unknown'}');
      }
    } on DioException catch (dioErr) {
      switch (dioErr.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException('Request timeout');
        case DioExceptionType.badResponse:
          final status = dioErr.response?.statusCode;
          if (status == 401) throw UnauthorizedException('Unauthorized');
          if (status == 404) throw NotFoundException('Not found');
          if (status != null && status >= 500) throw ServerException(status, 'Server error');
          throw NetworkException('HTTP error ${status ?? 'unknown'}');
        case DioExceptionType.cancel:
          throw NetworkException('Request cancelled');
        case DioExceptionType.unknown:
        case DioExceptionType.badCertificate:
        default:
          throw NetworkException(dioErr.message ?? 'Network error');
      }
    } on FormatException catch (fe) {
      throw ParsingException(fe.message);
    } on Exception catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  Future<User?> get user async {
    try {
      final User? user = _userPreferences.getUser();
      return user;
    } on FormatException catch (fe) {
      throw ParsingException(fe.message);
    } on Exception catch (e) {
      throw StorageException(e.toString());
    }
  }
}
