// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fake_store_prog/core/api/api_client.dart' as _i58;
import 'package:fake_store_prog/core/local/user_preferences.dart' as _i540;
import 'package:fake_store_prog/core/repositories/i_cart_repository.dart'
    as _i591;
import 'package:fake_store_prog/core/usecases/add_to_cart_use_case.dart'
    as _i1067;
import 'package:fake_store_prog/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i371;
import 'package:fake_store_prog/features/auth/data/repositories/auth_repository.dart'
    as _i110;
import 'package:fake_store_prog/features/auth/domain/repositories/i_auth_repository.dart'
    as _i267;
import 'package:fake_store_prog/features/auth/domain/usecases/login_use_case.dart'
    as _i172;
import 'package:fake_store_prog/features/auth/presentation/bloc/auth_bloc.dart'
    as _i651;
import 'package:fake_store_prog/features/cart/data/datasources/cart_local_data_source.dart'
    as _i626;
import 'package:fake_store_prog/features/cart/data/datasources/cart_remote_data_source.dart'
    as _i934;
import 'package:fake_store_prog/features/cart/data/repositories/cart_repository.dart'
    as _i239;
import 'package:fake_store_prog/features/cart/domain/usecases/confirm_cart_use_case.dart'
    as _i279;
import 'package:fake_store_prog/features/cart/domain/usecases/decrease_quantity_use_case.dart'
    as _i848;
import 'package:fake_store_prog/features/cart/domain/usecases/fetch_items_use_case.dart'
    as _i206;
import 'package:fake_store_prog/features/cart/domain/usecases/get_cart_list_use_case.dart'
    as _i996;
import 'package:fake_store_prog/features/cart/domain/usecases/get_total_price_use_case.dart'
    as _i865;
import 'package:fake_store_prog/features/cart/domain/usecases/increase_quantity_use_case.dart'
    as _i717;
import 'package:fake_store_prog/features/cart/domain/usecases/remove_item_use_case.dart'
    as _i205;
import 'package:fake_store_prog/features/cart/presentation/bloc/cart_bloc.dart'
    as _i53;
import 'package:fake_store_prog/features/product_list/data/datasources/product_list_remote_data_source.dart'
    as _i584;
import 'package:fake_store_prog/features/product_list/data/repositories/product_list_repository.dart'
    as _i360;
import 'package:fake_store_prog/features/product_list/domain/repositories/i_product_list_repository.dart'
    as _i378;
import 'package:fake_store_prog/features/product_list/domain/usecases/fetch_products_use_case.dart'
    as _i260;
import 'package:fake_store_prog/features/product_list/domain/usecases/get_user_use_case.dart'
    as _i918;
import 'package:fake_store_prog/features/product_list/presentation/bloc/product_list_bloc.dart'
    as _i13;
import 'package:fake_store_prog/features/product_viewer/bloc/product_viewer_bloc.dart'
    as _i775;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i865.GetTotalPriceUseCase>(() => _i865.GetTotalPriceUseCase());
    gh.lazySingleton<_i58.ApiClient>(() => _i58.ApiClient());
    gh.lazySingleton<_i540.UserPreferences>(() => _i540.UserPreferences());
    gh.lazySingleton<_i626.CartLocalDataSource>(
      () => _i626.CartLocalDataSource(gh<_i540.UserPreferences>()),
    );
    gh.factory<_i775.ProductViewerBloc>(
      () => _i775.ProductViewerBloc(apiClient: gh<_i58.ApiClient>()),
    );
    gh.lazySingleton<_i584.ProductListRemoteDataSource>(
      () => _i584.ProductListRemoteDataSource(
        gh<_i58.ApiClient>(),
        gh<_i540.UserPreferences>(),
      ),
    );
    gh.lazySingleton<_i371.AuthRemoteDataSource>(
      () => _i371.AuthRemoteDataSource(gh<_i58.ApiClient>()),
    );
    gh.lazySingleton<_i934.CartRemoteDataSource>(
      () => _i934.CartRemoteDataSource(gh<_i58.ApiClient>()),
    );
    gh.lazySingleton<_i267.IAuthRepository>(
      () => _i110.AuthRepository(
        remote: gh<_i371.AuthRemoteDataSource>(),
        userPreferences: gh<_i540.UserPreferences>(),
      ),
    );
    gh.lazySingleton<_i378.IProductListRepository>(
      () => _i360.ProductListRepository(
        remoteDataSource: gh<_i584.ProductListRemoteDataSource>(),
        userPreferences: gh<_i540.UserPreferences>(),
      ),
    );
    gh.factory<_i260.FetchProductsUseCase>(
      () => _i260.FetchProductsUseCase(gh<_i378.IProductListRepository>()),
    );
    gh.factory<_i918.GetUserUseCase>(
      () => _i918.GetUserUseCase(gh<_i378.IProductListRepository>()),
    );
    gh.lazySingleton<_i591.ICartRepository>(
      () => _i239.CartRepository(
        localDataSource: gh<_i626.CartLocalDataSource>(),
        remoteDataSource: gh<_i934.CartRemoteDataSource>(),
      ),
    );
    gh.factory<_i13.ProductListBloc>(
      () => _i13.ProductListBloc(
        fetchProductsUseCase: gh<_i260.FetchProductsUseCase>(),
        getUserUseCase: gh<_i918.GetUserUseCase>(),
      ),
    );
    gh.factory<_i172.LoginUseCase>(
      () => _i172.LoginUseCase(gh<_i267.IAuthRepository>()),
    );
    gh.factory<_i1067.AddToCartUseCase>(
      () =>
          _i1067.AddToCartUseCase(cartRepository: gh<_i591.ICartRepository>()),
    );
    gh.factory<_i848.DecreaseQuantityUseCase>(
      () => _i848.DecreaseQuantityUseCase(
        cartRepository: gh<_i591.ICartRepository>(),
      ),
    );
    gh.factory<_i206.FetchItemsUseCase>(
      () =>
          _i206.FetchItemsUseCase(cartRepository: gh<_i591.ICartRepository>()),
    );
    gh.factory<_i996.GetCartListUseCase>(
      () =>
          _i996.GetCartListUseCase(cartRepository: gh<_i591.ICartRepository>()),
    );
    gh.factory<_i717.IncreaseQuantityUseCase>(
      () => _i717.IncreaseQuantityUseCase(
        cartRepository: gh<_i591.ICartRepository>(),
      ),
    );
    gh.factory<_i205.RemoveItemUseCase>(
      () =>
          _i205.RemoveItemUseCase(cartRepository: gh<_i591.ICartRepository>()),
    );
    gh.factory<_i279.ConfirmCartUseCase>(
      () => _i279.ConfirmCartUseCase(
        cartRepository: gh<_i591.ICartRepository>(),
        userPreferences: gh<_i540.UserPreferences>(),
      ),
    );
    gh.factory<_i651.AuthBloc>(
      () => _i651.AuthBloc(loginUseCase: gh<_i172.LoginUseCase>()),
    );
    gh.factory<_i53.CartBloc>(
      () => _i53.CartBloc(
        decreaseQuantityUseCase: gh<_i848.DecreaseQuantityUseCase>(),
        fetchItemsUseCase: gh<_i206.FetchItemsUseCase>(),
        getCartListUseCase: gh<_i996.GetCartListUseCase>(),
        getTotalPriceUseCase: gh<_i865.GetTotalPriceUseCase>(),
        increaseQuantityUseCase: gh<_i717.IncreaseQuantityUseCase>(),
        removeItemUseCase: gh<_i205.RemoveItemUseCase>(),
        confirmCartUseCase: gh<_i279.ConfirmCartUseCase>(),
      ),
    );
    return this;
  }
}
