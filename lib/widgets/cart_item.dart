import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItem(this.id, this.price, this.quantity, this.title, this.productId, {super.key});

  @override
  Widget build(BuildContext context) {
    // remove section
    
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) =>  showDialog(
        context: context, builder: (ctx) => AlertDialog(
          title: Text('Are you sure ?'),
          content: Text('Do you want to remove the item from the cart'),
          actions: [
            TextButton(onPressed: (){

           Navigator.of(context).pop(false);

            }, child: const Text('NO')
            ),
            TextButton(onPressed: (){

               Navigator.of(context).pop(true);

            }, child: const Text('YES')
            )
          ],
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },

// remove senton end

      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.greenAccent[400],
              radius: 50,
              child:
                  Text('\$$price', style: const TextStyle(color: Colors.white)),
            ),
            title: Text(title),
            subtitle: Text('Total\$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
