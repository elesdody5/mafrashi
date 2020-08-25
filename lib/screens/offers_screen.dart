import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/providers/products.dart';
import 'package:mafrashi/widgets/error_widget.dart';
import 'package:mafrashi/widgets/products_grid.dart';
import 'package:provider/provider.dart';

class OffersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('offers')),
      ),
      body: FutureBuilder(
        future:
            Provider.of<ProductsProvider>(context, listen: false).fetchOffers(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if (snapShot.error != null)
            return Center(child: ErrorImage());
          else {
            return Consumer<ProductsProvider>(
              builder: (_, provider, __) {
                if (provider.productOffers.isEmpty) {
                  return Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Image.asset('assets/images/offer.png'),
                      Text(AppLocalizations.of(context).translate('no_offers')),
                    ]),
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).translate('discount'),
                            style: Theme.of(context).textTheme.title,
                          ),
                          Text(provider.discount),
                        ],
                      ),
                    ),
                    Expanded(child: ProductsGrid(provider.productOffers))
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
