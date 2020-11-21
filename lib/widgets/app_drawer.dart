import 'package:SHOP_APP/helper/customeRoute.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/order_screen.dart';
import '../providers/auth.dart';
import '../screen/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friends!'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            title: Text('Shop'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            onTap: () {
               Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
              // Navigator.of(context).pushReplacement(
              //     CustomeRoute(builder: (ctx) => OrderScreen()));
            },
            title: Text('Orders'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
            title: Text('Manage Products'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
