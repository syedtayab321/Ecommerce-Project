import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';

class InvoiceScreen extends StatelessWidget {
  final String userName;

  InvoiceScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice of ' + userName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .doc(userName)
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
          var productData;

          // Group invoices by id
          Map<String, List<QueryDocumentSnapshot>> groupedInvoices = {};
          for (var doc in invoices) {
            var productData = doc.data() as Map<String, dynamic>;
            String productId = productData['Product id'];

            if (!groupedInvoices.containsKey(productId)) {
              groupedInvoices[productId] = [];
            }
            groupedInvoices[productId]!.add(doc);
          }

          return ListView.builder(
            itemCount: groupedInvoices.keys.length,
            itemBuilder: (context, index) {
              String productId = groupedInvoices.keys.elementAt(index);
              List<
                  QueryDocumentSnapshot> idInvoices = groupedInvoices[productId]!;

              double totalCostForId = idInvoices.fold(0, (sum, doc) {
                productData = doc.data() as Map<String, dynamic>;
                return sum + (productData['Total Price'] ?? 0);
              });

              return Card(
                color: Colors.black87,
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextWidget(
                          title: 'Brand Way Food Ltd',
                          color: Colors.white,
                          size: 20,
                          spacing: 3,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget(
                            title: 'Name:        ',
                            color: Colors.green,
                            size: 18,
                          ),
                          TextWidget(
                            title: userName,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget(
                            title: 'Date:        ',
                            color: Colors.green,
                            size: 18,
                          ),
                          TextWidget(
                            title: productData['Date'],
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget(
                            title: 'Address:    ',
                            color: Colors.green,
                            size: 18,
                          ),
                          TextWidget(
                            title: productData['Address'],
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget(
                            title: 'Product Id:   ',
                            color: Colors.white,
                            size: 18,
                          ),
                          TextWidget(
                            title: productId,
                            color: Colors.white,
                            size: 15,
                          ),
                        ],
                      ),
                      Divider(color: Colors.white),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget(
                            title: 'Product Name',
                            color: Colors.white,
                            size: 16,
                          ),
                          Spacer(),
                          TextWidget(
                            title: 'Quantity',
                            color: Colors.white,
                            size: 16,
                          ),
                          Spacer(),
                          TextWidget(
                            title: 'Total Price',
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                      Divider(color: Colors.white),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: idInvoices.length,
                        itemBuilder: (context, index) {
                          var productData = idInvoices[index].data() as Map<
                              String,
                              dynamic>;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  TextWidget(
                                    title: '${productData['Product Name']}',
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  Spacer(),
                                  TextWidget(
                                    title: '${productData['Selected quantity']}'
                                        .toString(),
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  Spacer(),
                                  TextWidget(
                                    title: '\£${productData['Total Price']
                                        .toString()}',
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      Divider(color: Colors.white),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              TextWidget(
                                title: 'Total Price',
                                color: Colors.white,
                                size: 16,
                              ),
                              Spacer(),
                              TextWidget(
                                title: '\£${productData['Price Before Discount']
                                    .toString()}',
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextWidget(
                                title: 'Discount',
                                color: Colors.white,
                                size: 16,
                              ),
                              Spacer(),
                              TextWidget(
                                title: '${productData['Discount']
                                    .toString()}\%',
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextWidget(
                                title: 'Payable Price',
                                color: Colors.white,
                                size: 16,
                              ),
                              Spacer(),
                              TextWidget(
                                title: productData['Price After Discount']
                                    .toString(),
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(color: Colors.white),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextWidget(
                          title: 'Thanks for Shopping!!!!!',
                          color: Colors.white,
                          size: 20,
                          spacing: 3,
                        ),
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
