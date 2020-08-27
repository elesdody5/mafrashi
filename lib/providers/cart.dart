import 'package:flutter/foundation.dart';
import 'package:mafrashi/data_layer/repository/products_repository.dart';
import 'package:mafrashi/model/cart.dart';

class CartProvider with ChangeNotifier {
  ProductRepository _productRepository;

  CartProvider(this._productRepository);

  Cart _cart;

  Cart get cart => _cart;

  List<CartItem> get items {
    if (_cart == null || _cart.cartItems == null) return [];
    return [..._cart.cartItems];
  }

  int get itemCount {
    return items.length ?? 0;
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

  void removeItem(int cartId) async {
    bool result = await _productRepository.removeFromCart(cartId);
    if (result) {
      _cart.cartItems.removeWhere((cart) => cart.id == cartId);
      notifyListeners();
    }
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

  Future<bool> moveToWishList(int cartId) async {
    bool result = await _productRepository.moveFromCartToWishList(cartId);
    if (result) _cart.cartItems.removeWhere((cart) => cart.id == cartId);
    notifyListeners();
    return result;
  }
}
