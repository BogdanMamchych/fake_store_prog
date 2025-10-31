import 'package:dio/dio.dart';
import 'package:fake_store_prog/core/models/item.dart';
import 'package:fake_store_prog/core/api/api_client.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/local/exceptions.dart';

@injectable
class CartRemoteDataSource {
  final ApiClient _apiClient;

  CartRemoteDataSource(this._apiClient);

  Future<Item> getItemById(int id) async {
    try {
      final response = await _apiClient.getItemById(id);

      final status = response.statusCode ?? 0;
      if (status == 200 || status == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          try {
            return Item.fromJson(data);
          } catch (e) {
            throw ParsingException('Failed to parse product JSON: $e');
          }
        } else {
          throw ParsingException(
            'Expected product JSON object, got: ${data.runtimeType}',
          );
        }
      } else if (status == 404) {
        throw NotFoundException('Product with id $id not found (404)');
      } else if (status == 401 || status == 403) {
        throw UnauthorizedException(
          'Unauthorized access when fetching product $id (status: $status)',
        );
      } else {
        throw ServerException(status, response.statusMessage ?? 'Server error');
      }
    } on DioException catch (dioErr) {
      throw _mapDioException(dioErr);
    } catch (e) {
      throw UnexpectedException(
        'Unexpected error while fetching product $id: $e',
      );
    }
  }


  Future<void> confirmCart(Map<String, dynamic> cartData) async {
    try {
      final response = await _apiClient.postNewCart(cartData);
      final status = response.statusCode ?? 0;

      if (status == 200 || status == 201) {
        return;
      } else if (status == 400) {
        final message =
            (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : 'Bad request';
        throw ServerException(status, message);
      } else if (status == 401 || status == 403) {
        throw UnauthorizedException(
          'Unauthorized to confirm cart (status: $status)',
        );
      } else {
        throw ServerException(status, response.statusMessage ?? 'Server error');
      }
    } on DioException catch (dioErr) {
      throw _mapDioException(dioErr);
    } catch (e) {
      throw UnexpectedException(
        'Unexpected error while confirming cart: $e',
      );
    }
  }

  Exception _mapDioException(DioException dioErr) {
  // 1) Таймаути / cancel / connectionError
  final type = dioErr.type;
  if (type == DioExceptionType.connectionTimeout ||
      type == DioExceptionType.receiveTimeout ||
      type == DioExceptionType.sendTimeout) {
    final msg = dioErr.message ?? 'Request timeout';
    return TimeoutException(msg);
  }

  if (type == DioExceptionType.cancel) {
    final msg = dioErr.message ?? 'Request was cancelled';
    return UnexpectedException(msg);
  }

  if (type == DioExceptionType.connectionError || type == DioExceptionType.unknown) {
    final msg = dioErr.message ?? 'Network error';
    return NetworkException(msg);
  }

  final resp = dioErr.response;
  if (resp != null) {
    final status = resp.statusCode ?? 0;
    final bodyPreview = (resp.data != null) ? resp.data.toString() : '';
    final baseMsg = bodyPreview.isNotEmpty ? '$bodyPreview' : (resp.statusMessage ?? '');

    if (status == 401 || status == 403) {
      return UnauthorizedException('Unauthorized (status: $status). $baseMsg');
    } else if (status == 404) {
      return NotFoundException('Resource not found (status: 404). $baseMsg');
    } else {
      return ServerException(status, 'Server error (status: $status). $baseMsg');
    }
  }

  final message = dioErr.message ?? 'Network error';
  return NetworkException(message);
}

}
