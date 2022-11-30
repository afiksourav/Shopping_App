import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) { 
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        
      ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null.toString(), null.toString(), []),
          update: (ctx, auth, previousProducts) =>
           Products(
            auth.token.toString(),
            previousProducts!.userId,
            previousProducts == false ? [] : previousProducts.items,
          ),
        ),
        
        ChangeNotifierProvider(  
          create: (ctx) => Cart(),
        ),
      ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(null.toString(), null.toString(), []),
          update: (ctx, auth, previousOrders) => Orders(
            auth.token.toString(),
             auth.userId, 
             previousOrders == null ?[]: previousOrders.orders)
        ),
      ],
     child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth ?
              ProductsOverviewScreen() :
               FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: ((context, snapshot) =>
                 snapshot.connectionState == ConnectionState.waiting ?
                 SplashScreen()  :AuthScreen())
                ),
          routes: {
            ProductDetaiScreen.routeName: (ctx) => ProductDetaiScreen(),
            CartScreen.routeName:(ctx)=> CartScreen(),
            OrderScreen.routeName:(ctx)=> OrderScreen(),
            UserProductsScreen.routeName:(ctx) => UserProductsScreen(),
            EditProductScreen.routeName:(ctx) => EditProductScreen(),
          }),

       ) 
    );
  } 
}
