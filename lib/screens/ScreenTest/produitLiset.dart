import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return Center(
              child: Text('No products available'),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(product['name']),
                subtitle: Text(product['description']),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(product['image']),
                ),
                // You can add more functionality here, like editing or deleting the product
              );
            },
          );
        },
      ),
    );
  }
}