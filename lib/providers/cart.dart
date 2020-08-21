import 'package:flutter/foundation.dart';
import 'package:mafrashi/data_layer/repository/products_repository.dart';
import 'package:mafrashi/model/cart.dart';

class CartProvider with ChangeNotifier {
  ProductRepository _productRepository;

  CartProvider(this._productRepository);

  List<Cart> _items = [];

  List<Cart> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((cartItem) {
      total += double.parse(cartItem.price) * cartItem.quantity;
    });
    return total;
  }

  Future<bool> addItem(int productId, int quantity, int colorId, int sizeId,
      int variantId) async {
    try {
      await _productRepository.addToCart(
          productId, quantity, colorId, sizeId, variantId);
      fetchCartItems();
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
    if (result) _items.removeWhere((cart) => cart.productId == productId);
    notifyListeners();
  }

  void removeSingleItem(int productId) {
    if (!_items.contains(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
//      _items.update(
//          productId,
//          (existingCartItem) => CartItem(
//                id: existingCartItem.id,
//                title: existingCartItem.title,
//                price: existingCartItem.price,
//                quantity: existingCartItem.quantity - 1,
//              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  Future<void> fetchCartItems() async {
    _items = await _productRepository.fetchCartList();
    notifyListeners();
  }

  void clear() {
    _items = [];
    notifyListeners();
  }
}
