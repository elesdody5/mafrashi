import 'package:flutter/material.dart';
import 'package:mafrashi/data_layer/remote_data/auth/auth_api_data.dart';
import 'package:mafrashi/data_layer/remote_data/auth/auth_data_interface.dart';
import 'package:mafrashi/data_layer/remote_data/network.dart';
import 'package:mafrashi/data_layer/remote_data/network_interface.dart';
import 'package:mafrashi/data_layer/repository/auth_repository.dart';
import 'package:mafrashi/data_layer/repository/products_repository.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';
import 'package:mafrashi/providers/products.dart';
import 'package:mafrashi/screens/auth_screen.dart';
import 'package:mafrashi/screens/products_overview_screen.dart';
import 'package:mafrashi/screens/welcom_screen.dart';
import 'package:provider/provider.dart';

import './helpers/custom_route.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final UserManager _userManager = UserManagerImp();
  final RemoteDataSource _remoteDataSource = Network();
  final AuthApi _authApi = AuthApiImp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: AuthRepositoryImp(_userManager, _authApi)),
        ChangeNotifierProvider.value(
            value: ProductRepository(_remoteDataSource, _userManager)),
        ChangeNotifierProxyProvider<AuthRepositoryImp, Auth>(
          update: (ctx, authRepo, previousAuth) => Auth(authRepo),
        ),
        ChangeNotifierProxyProvider<ProductRepository, ProductsProvider>(
            update: (ctx, productRepo, previousProducts) =>
                previousProducts == null
                    ? ProductsProvider(productRepo)
                    : previousProducts),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
//        ChangeNotifierProxyProvider<Auth, Orders>(
//          builder: (ctx, auth, previousOrders) => Orders(
//            auth.token,
//            auth.userId,
//            previousOrders == null ? [] : previousOrders.orders,
//          ),
//        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primaryColor: Color(0xFFA8A73A),
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            },
          ),
        ),
        home: WelcomePage(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen()
        },
      ),
    );
  }
}
