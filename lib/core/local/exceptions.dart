class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error']);
  @override
  String toString() => 'NetworkException: $message';
}

class InvalidCredentialsException implements Exception {
  final String message;
  InvalidCredentialsException([this.message = 'Invalid credentials']);
  @override
  String toString() => 'InvalidCredentialsException: $message';
}

class ServerException implements Exception {
  final int? statusCode;
  final String message;
  ServerException(this.statusCode, [this.message = 'Server error']);
  @override
  String toString() => 'ServerException($statusCode): $message';
}

class StorageException implements Exception {
  final String message;
  StorageException([this.message = 'Storage error']);
  @override
  String toString() => 'StorageException: $message';
}

class UnexpectedException implements Exception {
  final String message;
  UnexpectedException([this.message = 'Unexpected error']);
  @override
  String toString() => 'UnexpectedException: $message';
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException([this.message = 'Request timeout']);
  @override
  String toString() => 'TimeoutException: $message';
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Unauthorized']);
  @override
  String toString() => 'UnauthorizedException: $message';
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = 'Not found']);
  @override
  String toString() => 'NotFoundException: $message';
}

class ParsingException implements Exception {
  final String message;
  ParsingException([this.message = 'Parsing error']);
  @override
  String toString() => 'ParsingException: $message';
}

class ItemNotFoundException implements Exception {
  final String message;
  ItemNotFoundException([this.message = 'Item not found']);
  @override
  String toString() => 'ItemNotFoundException: $message';
}
