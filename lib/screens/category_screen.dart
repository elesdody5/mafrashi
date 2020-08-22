import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/providers/category_provider.dart';
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
  Category _category;

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
    _category = categoryProvider.findCategoryById(categoryId);
    categoryProvider.currentCategorySlug = _category.slug;
    await categoryProvider.fetchSubCategory(_category.id);
    await Provider.of<CategoryProvider>(context, listen: false)
        .fetchProductsByCategory(_category.slug);
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
                Consumer<CategoryProvider>(builder: (context, provider, _) {
                  return Visibility(
                    visible: provider.subCategory.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context).translate('sub_category'),
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  );
                }),
                Consumer<CategoryProvider>(builder: (context, provider, _) {
                  return Visibility(
                    visible: provider.subCategory.isNotEmpty,
                    child: Flexible(flex: 1, child: SubCategoryGrid()),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_category.name,
                      style: Theme.of(context).textTheme.title),
                ),
                Flexible(
                    flex: 7,
                    child: Consumer<CategoryProvider>(
                        builder: (_, provider, child) {
                      if (provider.productCategory.isEmpty) {
                        return Center(
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Image.asset('assets/images/empty_list.png'),
                            Text(AppLocalizations.of(context)
                                .translate('empty_category')),
                          ]),
                        );
                      } else {
                        return ProductsGrid(provider.productCategory);
                      }
                    }))
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
