import 'package:flutter/foundation.dart';
import 'package:mafrashi/data_layer/repository/products_repository.dart';
import 'package:mafrashi/model/cart.dart';

class CartProvider with ChangeNotifier {
  ProductRepository _productRepository;

  CartProvider(this._productRepository);
  Cart _cart;

  Cart get cart => _cart;

  List<CartItem> get items {
    if (_cart == null) return [];
    return [..._cart.cartItems] ?? [];
  }

  int get itemCount {
    return items.length;
  }

  String get subTotal {
    return _cart.formattedSubTotal;
  }

  String get totalAfterDiscount {
    return _cart.formattedGrandTotal;
  }

  String get discount {
    return _cart.formattedDiscount;
  }

  String get tax {
    return _cart.formattedTax;
  }

  Future<bool> addItem(int productId, int quantity, int colorId, int sizeId,
      int variantId) async {
    try {
      bool added = await _productRepository.addToCart(
          productId, quantity, colorId, sizeId, variantId);
      if (added) {
        // to just update badge in home screen
        _cart.cartItems.add(CartItem());
        notifyListeners();
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<String> addCoupon(int code) async {
    return await _productRepository.addCoupon(code);
  }

  void removeItem(int productId) async {
    print(productId);
    bool result = await _productRepository.removeFromCart(productId);
    if (result)
      _cart.cartItems.removeWhere((cart) => cart.productId == productId);
    notifyListeners();
  }

  void removeSingleItem(int productId) {
    if (!_cart.cartItems.contains(productId)) {
      return;
    }
    if (_cart.cartItems[productId].quantity > 1) {
//      _cart.cartItems.update(
//          productId,
//          (existingCartItem) => CartItem(
//                id: existingCartItem.id,
//                title: existingCartItem.title,
//                price: existingCartItem.price,
//                quantity: existingCartItem.quantity - 1,
//              ));
    } else {
      _cart.cartItems.remove(productId);
    }
    notifyListeners();
  }

  Future<void> fetchCartItems() async {
    _cart = await _productRepository.fetchCartList();
    notifyListeners();
  }

  Future<String> deleteCoupon() async {
    return await _productRepository.deleteCoupon();
  }

  void clear() {
    _cart.cartItems = [];
    notifyListeners();
  }
}
