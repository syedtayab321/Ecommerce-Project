import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceScreen extends StatelessWidget {
  var UserCnic;
  InvoiceScreen({required this.UserCnic});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:FirebaseFirestore.instance.collection('Orders').doc(UserCnic).collection('Buyed Products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No invoices found.'));
          }
          final invoices = snapshot.data!;
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var ProductData =snapshot.data!.docs[index].data() as Map<String ,dynamic>;
              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User Name: ${ProductData['Product Name']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('CNIC: ${this.UserCnic}', style: TextStyle(fontSize: 16)),
                      Text('Date: ${ProductData['Date']}', style: TextStyle(fontSize: 16)),
                      Divider(),

                      Divider(),
                      Text('Total: \$${ProductData['Total Price']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
