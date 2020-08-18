import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/providers/category_provider.dart';
import 'package:mafrashi/providers/products.dart';
import 'package:mafrashi/widgets/error_widget.dart';
import 'package:mafrashi/widgets/products_grid.dart';
import 'package:mafrashi/widgets/sub_category_grid.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/category';
  final int categoryId;
  CategoryScreen(this.categoryId);
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
    final categoryId = widget.categoryId;
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    Category category = categoryProvider.findCategoryById(categoryId);
    print(category.name);
    await categoryProvider.fetchSubCategory(category.slug);
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProductsByCategory(category.slug);
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildBody() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context).translate('categories'),
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Flexible(flex: 1, child: SubCategoryGrid()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      AppLocalizations.of(context).translate('all_products'),
                      style: Theme.of(context).textTheme.title),
                ),
                Flexible(
                    flex: 4,
                    child: Consumer<ProductsProvider>(
                        builder: (_, products, ch) =>
                            ProductsGrid(products.items)))
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
        ),
        body: _showError ? ErrorImage() : _buildBody());
  }
}
