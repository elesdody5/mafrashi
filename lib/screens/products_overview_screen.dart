import 'package:flutter/material.dart';
import 'package:mafrashi/widgets/authenticated_widget.dart';
import 'package:mafrashi/widgets/bottom_navigation.dart';
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
      await Provider.of<ProductsProvider>(context).fetchCategories();
      await Provider.of<ProductsProvider>(context).fetchProducts();
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
        : ListView(children: [
            Text("All Categories:"),
            CategoriesGrid(),
            Text("All Products"),
            ProductsGrid()
          ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mafrashi'),
          actions: <Widget>[
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child: AuthenticatedWidget(
                  child: Icon(
                    Icons.shopping_cart,
                  ),
                  onTap: () =>
                      Navigator.of(context).pushNamed(CartScreen.routeName)),
            ),
          ],
        ),
        bottomNavigationBar: ButtomNavigaton(),
        body: _showError ? ErrorImage() : _buildBody());
  }
}
