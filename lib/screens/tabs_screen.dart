import 'package:fancy_bar/fancy_bar.dart';
import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/screens/category_screen.dart';
import 'package:mafrashi/screens/orders_screen.dart';
import 'package:mafrashi/screens/products_overview_screen.dart';
import 'package:mafrashi/screens/profile_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = "/tabs";

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Widget> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      ProductsOverviewScreen(),
      CategoryScreen(),
      OrdersScreen(),
      ProfileScreen()
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedPageIndex],
        bottomNavigationBar: FancyBottomBar(
          type: FancyType.FancyV1, // Fancy Bar Type
          items: [
            FancyItem(
              textColor: Colors.orange,
              title: AppLocalizations.of(context).translate('home'),
              icon: Icon(Icons.home),
            ),
            FancyItem(
              textColor: Colors.red,
              title: AppLocalizations.of(context).translate('wish_list'),
              icon: Icon(Icons.favorite),
            ),
            FancyItem(
              textColor: Colors.green,
              title: AppLocalizations.of(context).translate('orders'),
              icon: Icon(Icons.shopping_basket),
            ),
            FancyItem(
              textColor: Colors.brown,
              title: AppLocalizations.of(context).translate('profile'),
              icon: Icon(Icons.account_circle),
            ),
          ],
          onItemSelected: (index) {
            _selectPage(index);
          },
        ));
  }
}
