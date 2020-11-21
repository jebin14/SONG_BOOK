import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    this.id,
    this.price,
    this.title,
    this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  //final String token;
  //Cart(this.token,this._items);

  Map<String, CartItem> get item {
    return {..._items};
  }

  String get itemCount {
    return _items.length.toString();
  }

  double get totalAmount {
    double total = 0.00;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingValue) => CartItem(
          id: existingValue.id,
          title: existingValue.title,
          price: existingValue.price,
          quantity: existingValue.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingProduct) => CartItem(
            id: existingProduct.id,
            price: existingProduct.price,
            title: existingProduct.title,
            quantity: existingProduct.quantity - 1),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  clearCart() {
    _items = {};
    notifyListeners();
  }
}
