import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;

  // @override
  // void initState() {
  //  Future.delayed(Duration.zero).then((value) async  {
  //   setState(() {
  //     _isLoading= true;
  //   });
  //  await Provider.of<Orders>(context,listen: false).fetchAndSetOrders();

  //  setState(() {
  //     _isLoading= false;
  //   });
  //  });
  //   super.initState();
  // }

  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _ordersFuture,  // _ordersFuture ei method ta kaj kore oders fatch kore asha provider er sathe
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text('an error occourred'),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, orderData, child) => ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: ((context, index) =>
                            OrderItemsWidget(orderData.orders[index]))));
              }
            }
          },
        ));
  }
}
