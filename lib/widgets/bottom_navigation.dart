import 'package:fancy_bar/fancy_bar.dart';
import 'package:flutter/material.dart';

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
          title: 'Trending',
          icon: Icon(Icons.trending_up),
        ),
        FancyItem(
          textColor: Colors.green,
          title: 'Search',
          icon: Icon(Icons.search),
        ),
        FancyItem(
          textColor: Colors.brown,
          title: 'Settings',
          icon: Icon(Icons.settings),
        ),
      ],
      onItemSelected: (index) {
        print(index);
      },
    );
  }
}
