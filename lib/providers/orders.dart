import 'package:flutter/foundation.dart';
import 'package:mafrashi/data_layer/repository/products_repository.dart';
import 'package:mafrashi/model/order.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];
  List<String> _countries = [];

  ProductRepository _productRepository;

  Orders(this._productRepository);

  Map<String, dynamic> _addressData = {
    "billing": {
      "company_name": "",
      "first_name": "",
      "last_name": "",
      "email": "",
      "address1": {"": ""},
      "city": "",
      "country": "",
      "state": "",
      "postcode": "",
      "phone": "",
      "use_for_shipping": "1"
    },
    "shipping": {
      "first_name": "",
      "last_name": "",
      "email": "",
      "address1": {"": ""},
      "city": "",
      "country": "",
      "state": "",
      "postcode": "",
      "phone": "",
    },
    "shipping_method": "flaterate",
  };

  List<Order> get orders {
    return [..._orders];
  }

  List<String> get countries {
    return [..._countries];
  }

  void saveBillingAddress(Map<String, String> billingAddress) {
    _addressData['billing']["company_name"] = billingAddress['company_name'];
    _addressData['billing']["first_name"] = billingAddress['first_name'];
    _addressData['billing']["last_name"] = billingAddress['last_name'];
    _addressData['billing']["email"] = billingAddress['email'];
    _addressData['billing']["address1"][""] = billingAddress['street_address'];
    _addressData['billing']["city"] = billingAddress['city'];
    _addressData['billing']["country"] = billingAddress['country'];
    _addressData['billing']["state"] = billingAddress['state'];
    _addressData['billing']["postcode"] = billingAddress['postal_code'];
    _addressData['billing']["phone"] = billingAddress['phone'];
  }

  Future<bool> saveShippingAddress(Map<String, String> shippingAddress) async {
    _addressData['shipping']["first_name"] = shippingAddress['first_name'];
    _addressData['shipping']["last_name"] = shippingAddress['last_name'];
    _addressData['shipping']["email"] = shippingAddress['email'];
    _addressData['shipping']["address1"][""] =
        shippingAddress['street_address'];
    _addressData['shipping']["city"] = shippingAddress['city'];
    _addressData['shipping']["country"] = shippingAddress['country'];
    _addressData['shipping']["state"] = shippingAddress['state'];
    _addressData['shipping']["postcode"] = shippingAddress['postal_code'];
    _addressData['shipping']["phone"] = shippingAddress['phone'];
    return await _productRepository.saveAddress(_addressData);
  }

  Future<void> fetchAndSetOrders() async {}

  Future<void> getCountries() async {
    _countries = await _productRepository.countries();
    notifyListeners();
  }

  Future<bool> addOrder() async {
    return await _productRepository.order();
  }
}
