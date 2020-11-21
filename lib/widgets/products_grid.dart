import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products.dart';

class  ProductsGrid extends StatelessWidget {
  final bool _showFavorites;

  ProductsGrid(this._showFavorites);

  @override
  Widget build(BuildContext context) {
    final productDate = Provider.of<Products>(context);
    final product =
        _showFavorites ? productDate.getFavorites() : productDate.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        value: product[i],
        child: ProductItem(),
      ),
      itemCount: product.length,
      padding: const EdgeInsets.all(10.0),
    );
  }
}
