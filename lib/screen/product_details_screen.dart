import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routeName = '/product-detail';
  // final String title;

  // ProductDetailsScreen(this.title);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProducts = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(loadedProducts.title),
        // ),
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              loadedProducts.title,
              style: TextStyle(color: Colors.white),
            ),
            background: Hero(
              tag: loadedProducts.id,
              child: Image.network(
                loadedProducts.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(height: 10),
          Text(
            '\$${loadedProducts.price}',
            style: TextStyle(fontSize: 20, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              loadedProducts.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          SizedBox(
            height: 800,
          )
        ]))
      ],
    ));
  }
}
