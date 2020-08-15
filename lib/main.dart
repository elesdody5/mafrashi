import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mafrashi/data_layer/remote_data/auth/auth_api_data.dart';
import 'package:mafrashi/data_layer/remote_data/auth/auth_data_interface.dart';
import 'package:mafrashi/data_layer/remote_data/product_data/product_api.dart';
import 'package:mafrashi/data_layer/remote_data/product_data/product_interface.dart';
import 'package:mafrashi/data_layer/remote_data/user_data/user_api.dart';
import 'package:mafrashi/data_layer/repository/auth_repository.dart';
import 'package:mafrashi/data_layer/repository/products_repository.dart';
import 'package:mafrashi/data_layer/repository/user_repository.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';
import 'package:mafrashi/providers/category_provider.dart';
import 'package:mafrashi/providers/products.dart';
import 'package:mafrashi/providers/profile.dart';
import 'package:mafrashi/screens/auth_screen.dart';
import 'package:mafrashi/screens/category_screen.dart';
import 'package:mafrashi/screens/products_overview_screen.dart';
import 'package:mafrashi/screens/splash_screen.dart';
import 'package:mafrashi/screens/tabs_screen.dart';
import 'package:mafrashi/screens/welcom_screen.dart';
import 'package:provider/provider.dart';

import './helpers/custom_route.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import 'helpers/slide_route.dart';
import 'language/app_loacl.dart';
import 'providers/change_language_provider.dart';

void main() async {
  // Always call this if the main method is asynchronous
  WidgetsFlutterBinding.ensureInitialized();

  final AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();

  runApp(ChangeNotifierProvider<AppLanguage>.value(
      value: appLanguage,
      child: MyApp(
        appLanguage: appLanguage,
      )));
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});

  final UserManager _userManager = UserManagerImp();
  final RemoteDataSource _remoteDataSource = ProductApi();
  final AuthApi _authApi = AuthApiImp();
  final ProfileApi _profileApi = ProfileApiImp();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: AuthRepositoryImp(_userManager, _authApi)),
        ChangeNotifierProvider.value(
            value: ProductRepository(_remoteDataSource, _userManager)),
        ChangeNotifierProvider.value(
            value: ProfileRepositoryImp(_userManager, _profileApi)),
        ChangeNotifierProxyProvider<AuthRepositoryImp, Auth>(
          update: (ctx, authRepo, previousAuth) => Auth(authRepo),
        ),
        ChangeNotifierProxyProvider<ProfileRepositoryImp, ProfileProvider>(
            update: (ctx, profileRepo, previousUserData) =>
                previousUserData == null
                    ? ProfileProvider(profileRepo)
                    : previousUserData),
        ChangeNotifierProxyProvider<ProductRepository, ProductsProvider>(
            update: (ctx, productRepo, previousProducts) =>
                previousProducts == null
                    ? ProductsProvider(productRepo)
                    : previousProducts),
        ChangeNotifierProxyProvider<ProductRepository, CategoryProvider>(
            update: (ctx, productRepo, previousCategory) =>
                previousCategory == null
                    ? CategoryProvider(productRepo)
                    : previousCategory),
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
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
          title: 'Mafrishi',
          theme: ThemeData(
            primaryColor: Color(0xFFA8A73A),
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            textTheme: ThemeData.light().textTheme.copyWith(
                body1: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                body2: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                title: TextStyle(
                  fontSize: 20,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold,
                )),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          locale: model.appLocal,
          debugShowCheckedModeBanner: false,
          //locale: model.appLocal,
          supportedLocales: [
            Locale('ar', ''),
            Locale('en', 'US'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: FutureBuilder(
              future: Provider.of<Auth>(context, listen: false).tryAutoLogin(),
              builder: (ctx, authResultSnapshot) {
                final auth = Provider.of<Auth>(context, listen: false);
                if (authResultSnapshot.connectionState ==
                    ConnectionState.waiting)
                  return SplashScreen();
                else if (auth.isAuthenticated)
                  return TabsScreen();
                else
                  return WelcomePage();
              }),
          routes: {
            TabsScreen.routeName: (ctx) => TabsScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            WelcomePage.routeName: (ctx) => WelcomePage()
          },
          onGenerateRoute: _generateRoute,
        );
      }),
    );
  }

  Route _generateRoute(RouteSettings settings) {
    final String routeName = settings.name;
    switch (routeName) {
      case CategoryScreen.routeName:
        return SlideRightRoute(page: CategoryScreen());
    }
  }
}
