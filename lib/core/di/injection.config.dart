// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fake_store_prog/core/api/api_client.dart' as _i58;
import 'package:fake_store_prog/core/local/token_storage.dart' as _i1026;
import 'package:fake_store_prog/core/local/user_preferences.dart' as _i540;
import 'package:fake_store_prog/features/auth/bloc/auth_bloc.dart' as _i263;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i58.ApiClient>(() => _i58.ApiClient());
    gh.lazySingleton<_i1026.TokenStorage>(() => _i1026.TokenStorage());
    gh.lazySingleton<_i540.UserPreferences>(() => _i540.UserPreferences());
    gh.factory<_i263.AuthBloc>(
      () => _i263.AuthBloc(
        apiClient: gh<_i58.ApiClient>(),
        tokenStorage: gh<_i1026.TokenStorage>(),
        userPreferences: gh<_i540.UserPreferences>(),
      ),
    );
    return this;
  }
}
