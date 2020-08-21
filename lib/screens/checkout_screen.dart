import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/widgets/billing_address.dart';
import 'package:mafrashi/widgets/shipping_address.dart';

class CheckOutScreen extends StatefulWidget {
  static const routeName = "/checkout";

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
//  final GlobalKey<FormState> _billingKey = GlobalKey();
//  final GlobalKey<FormState> _billingKey = GlobalKey();

  var _isLoading = false;
  bool _billingValid = false;
  bool _shippinValid = false;
  final _swiperController = SwiperController();

  void moveNext() {
    _swiperController.next(animation: true);
  }

  void movePrevious() {
    _swiperController.previous(animation: true);
  }

  List<Widget> _checkoutForms = [];
  @override
  void initState() {
    super.initState();
    _checkoutForms = [
      BillingAddress(moveNext),
      ShippingAddress(moveNext, movePrevious),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate("proceed_to_checkout")),
      ),
      body: Swiper(
        controller: _swiperController,
        itemBuilder: (BuildContext context, int index) {
          return _checkoutForms[index];
        },
        itemCount: 2,
        loop: false,
        pagination: null,
        control: null,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
