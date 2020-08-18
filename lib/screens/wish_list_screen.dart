import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/providers/products.dart';
import 'package:mafrashi/widgets/products_grid.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("wish_list")),
      ),
      body: FutureBuilder(
          future: Provider.of<ProductsProvider>(context, listen: false)
              .fetchWishList(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                // ...
                // Do error handling stuff
                return Center(
                  child: Text('An error occurred!'),
                );
              } else {
                return Consumer<ProductsProvider>(
                    builder: (_, provider, child) {
                  if (provider.items.isEmpty) {
                    return Center(
                      child: GridTile(
                        child: Image.asset('assets/images/heart.png'),
                        footer: Text(AppLocalizations.of(context)
                            .translate('empty_wish_list')),
                      ),
                    );
                  } else {
                    return ProductsGrid(provider.wishList);
                  }
                });
              }
            }
          }),
    );
  }
}
