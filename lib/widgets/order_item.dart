import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/orders.dart';

class OrderItemsWidget extends StatefulWidget {
  final OrderItem orderProduct;

  OrderItemsWidget(this.orderProduct);

  @override
  State<OrderItemsWidget> createState() => _OrderItemsWidgetState();
}

class _OrderItemsWidgetState extends State<OrderItemsWidget> {
  var _expanded = false;
  

  @override
  Widget build(BuildContext context) {
     
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:_expanded ? min(widget.orderProduct.products.length * 20.0 + 110, 200)  : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.orderProduct.amount}'),
              subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                  .format(widget.orderProduct.dateTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
          
              AnimatedContainer(
                 duration: Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: _expanded? min(widget.orderProduct.products.length * 20.0 + 10, 100) : 0,
                child: ListView(
                    children: widget.orderProduct.products
                        .map((prod) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prod.title,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${prod.quantity} x \$${prod.price}',
                                  style:
                                      const TextStyle(fontSize: 18, color: Colors.grey),
                                )
                              ],
                            ))
                        .toList()),
              )
          ],
        ),
      ),
    );
  }
}
