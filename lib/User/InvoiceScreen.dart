import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceScreen extends StatelessWidget {
  final String userCnic;
  InvoiceScreen({required this.userCnic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice of ' + userCnic),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .doc(userCnic)
            .collection('Buyed Products')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: TextWidget(title: 'No invoices found.'));
          }

          final invoices = snapshot.data!.docs;

          // Group invoices by date
          Map<String, List<QueryDocumentSnapshot>> groupedInvoices = {};
          for (var doc in invoices) {
            var productData = doc.data() as Map<String, dynamic>;
            Timestamp timestamp = productData['Date'];
            DateTime dateTime = timestamp.toDate();
            String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);

            if (!groupedInvoices.containsKey(formattedDate)) {
              groupedInvoices[formattedDate] = [];
            }
            groupedInvoices[formattedDate]!.add(doc);
          }

          return ListView.builder(
            itemCount: groupedInvoices.keys.length,
            itemBuilder: (context, index) {
              String date = groupedInvoices.keys.elementAt(index);
              List<QueryDocumentSnapshot> dateInvoices = groupedInvoices[date]!;

              double totalCostForDate = dateInvoices.fold(0, (sum, doc) {
                var productData = doc.data() as Map<String, dynamic>;
                return sum + (productData['Price After Discount'] ?? 0);
              });

              return Card(
                color: Colors.black87,
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextWidget(
                          title: 'Date: $date',
                          size: 20,
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextWidget(
                          title: 'Total Cost:        \£${totalCostForDate.toStringAsFixed(2)}',
                          size: 20,
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Divider(color: Colors.white,),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: dateInvoices.length,
                        itemBuilder: (context, index) {
                          var productData = dateInvoices[index].data() as Map<String, dynamic>;
                          Timestamp timestamp = productData['Date'];
                          DateTime dateTime = timestamp.toDate();
                          String formattedTime = DateFormat('kk:mm').format(dateTime);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                title: 'Product Name:            ${productData['Product Name']}',
                                size: 16,
                                weight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              TextWidget(
                                title: 'CNIC:                            $userCnic',
                                size: 16,
                                color: Colors.white,
                              ),
                              TextWidget(
                                title: 'Time:                            $formattedTime',
                                size: 16,
                                color: Colors.white,
                              ),
                              TextWidget(
                                title: 'Total:                                 \£${productData['Price After Discount']}',
                                size: 16,
                                weight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              Divider(color: Colors.white,),
                            ],
                          );
                        },
                      ),
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