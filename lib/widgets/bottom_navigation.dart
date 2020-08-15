import 'package:fancy_bar/fancy_bar.dart';
import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';

class ButtomNavigaton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FancyBottomBar(
      type: FancyType.FancyV1, // Fancy Bar Type
      items: [
        FancyItem(
          textColor: Colors.orange,
          title: 'Home',
          icon: Icon(Icons.home),
        ),
        FancyItem(
          textColor: Colors.red,
          title: AppLocalizations.of(context).translate('categories'),
          icon: Icon(Icons.trending_up),
        ),
        FancyItem(
          textColor: Colors.green,
          title: AppLocalizations.of(context).translate('orders'),
          icon: Icon(Icons.search),
        ),
        FancyItem(
          textColor: Colors.brown,
          title: AppLocalizations.of(context).translate('settings'),
          icon: Icon(Icons.settings),
        ),
      ],
      onItemSelected: (index) {
        print(index);
      },
    );
  }
}
