import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/providers/category_provider.dart';
import 'package:mafrashi/widgets/error_widget.dart';
import 'package:mafrashi/widgets/products_grid.dart';
import 'package:provider/provider.dart';

class SubCategoryScreen extends StatelessWidget {
  static const routName = '/subCategory';

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    String categorySlug = arguments['category_slug'];
    String subCategorySlug = arguments['sub_category_slug'];
    String subCategoryName = arguments['sub_category_name'];
    return Scaffold(
      appBar: AppBar(
        title: Text(subCategoryName),
      ),
      body: FutureBuilder(
        future: Provider.of<CategoryProvider>(context, listen: false)
            .fetchProductsBySubCategory(categorySlug, subCategorySlug),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if (snapShot.error != null) {
            return Center(
              child: ErrorImage(),
            );
          } else {
            return Consumer<CategoryProvider>(builder: (_, provider, child) {
              if (provider.productSubCategory.isEmpty) {
                return Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Image.asset('assets/images/empty_list.png'),
                    Text(AppLocalizations.of(context)
                        .translate('empty_category')),
                  ]),
                );
              } else {
                return ProductsGrid(provider.productCategory);
              }
            });
          }
        },
      ),
    );
  }
}
