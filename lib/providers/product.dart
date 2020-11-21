import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.description,
    @required this.id,
    @required this.imageUrl,
    this.isFavorite = false,
    @required this.price,
    @required this.title,
  });

  void _setValue(bool oldValue) {
    isFavorite = oldValue;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    //var id=prod.id;
    final url = 'https://shopapp-9adbd.firebaseio.com/userFavorite/$userId/$id.json?auth=$token';
    final oldValue = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));

      if (response.statusCode >= 400) {
        _setValue(oldValue);
      }
    } catch (error) {
      _setValue(oldValue);
      print('issue');
    }

    //notifyListeners();
  }
}
