import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';


class ProductDetaiScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context)?.settings.arguments as String; // is the id!
   
   
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
      ).findById(productId);
  
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title,style: TextStyle(color: Color.fromARGB(255, 74, 15, 52)),),
         
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit:  BoxFit.cover,
                  ),
              ), 
              ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),
                Text(
                  '\$${loadedProduct.price}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
               Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
               child: Text(loadedProduct.description.toString(),
            textAlign: TextAlign.center,
            softWrap: true,
            style:const TextStyle(
                color: Colors.grey,
                fontSize: 20,
                
            ) 
               ),
             ),
             SizedBox(height: 800,)
            ]) ,
            )
        ],
     
      ),
    );
  }
}