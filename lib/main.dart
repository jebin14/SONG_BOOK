
import 'package:SHOP_APP/helper/customeRoute.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screen/product_details_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screen/cart_screen.dart';
import './providers/orders.dart';
import './screen/order_screen.dart';
import './screen/user_product_screen.dart';
import './screen/edit_product_screen.dart';
import './screen/auth_screen.dart';
import './providers/auth.dart';
import './screen/products_overview_screen.dart';
import './screen/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProd) => Products(
            auth.token,
            previousProd == null ? [] : previousProd.items,
            auth.userId,
          ),
          create: (ctx) => null,
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrder) => Orders(
            auth.token,
            auth.userId,
            previousOrder == null ? [] : previousOrder.order,
          ),
          create: (ctx) => null,
        ),
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                  fontFamily: 'Lato',
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android:CustomerRouteTransaction(),
                    TargetPlatform.iOS:CustomerRouteTransaction(),
                  })
                ),
                home: auth.isUserAuthentic
                    ? ProductsOverviewScreen()
                    : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
                routes: {
                  ProductDetailsScreen.routeName: (context) =>
                      ProductDetailsScreen(),
                  CartScreen.routeName: (context) => CartScreen(),
                  OrderScreen.routeName: (context) => OrderScreen(),
                  UserProductScreen.routeName: (context) => UserProductScreen(),
                  EditProductScreen.routeName: (context) => EditProductScreen(),
                },
              )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SHOP'),
      ),
      body: Center(
        child: Text('You have pushed the button this many times:'),
      ),
    );
  }
}
