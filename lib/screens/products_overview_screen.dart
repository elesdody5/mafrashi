import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/providers/category_provider.dart';
import 'package:mafrashi/widgets/authenticated_widget.dart';
import 'package:mafrashi/widgets/categories_grid.dart';
import 'package:mafrashi/widgets/error_widget.dart';
import 'package:provider/provider.dart';

import './cart_screen.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products_overview';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _showError = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      _fetchData();
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  void _fetchData() async {
    try {
//      await Provider.of<ProductsProvider>(context, listen: false)
//          .fetchWishList();
      await Provider.of<CategoryProvider>(context, listen: false)
          .fetchCategories();
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchProducts();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("products_overvie error$e");
      setState(() {
        _showError = true;
        _isLoading = false;
      });
    }
  }

  Widget _buildBody() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('categories'),
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Flexible(flex: 1, child: CategoriesGrid()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  AppLocalizations.of(context).translate('all_products'),
                  style: Theme.of(context).textTheme.title),
            ),
            Flexible(
              flex: 5,
              child: Consumer<ProductsProvider>(
                  builder: (_, products, ch) => ProductsGrid(products.items)),
            )
          ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('app_name'),
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child: AuthenticatedWidget(
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onTap: () =>
                      Navigator.of(context).pushNamed(CartScreen.routeName)),
            ),
          ],
        ),
        body: _showError ? ErrorImage() : _buildBody());
  }
}
