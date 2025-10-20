import 'package:jwt_decoder/jwt_decoder.dart';

String? extractUserIdFromToken(String token) {
  if (token.isEmpty) return null;
  try {
    Map<String, dynamic> decoded = JwtDecoder.decode(token);
    return decoded['sub']?.toString();
  } catch (e) {
    return 'Error decoding token: \$e';
  }
}