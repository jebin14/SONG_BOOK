import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/userProduct_item.dart';
import '../providers/products.dart';
import '../screen/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const String routeName = 'user-products';

  Future<void> _onRefresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _onRefresh(context),
        builder: (ctx, snapshort) =>
            snapshort.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _onRefresh(context),
                    child: Consumer<Products>(
                      builder: (ctx, prod, ch) => Padding(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: prod.items.length,
                            itemBuilder: (ctx, i) => Column(
                                  children: [
                                    UserProductItem(
                                        prod.items[i].id,
                                        prod.items[i].title,
                                        prod.items[i].imageUrl),
                                    Divider(),
                                  ],
                                )),
                      ),
                    ),
                  ),
      ),
    );
  }
}
