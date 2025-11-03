import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

@module
abstract class RegisterModule {
  FlutterSecureStorage get secureStorage => FlutterSecureStorage();
}
