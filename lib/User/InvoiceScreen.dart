import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceScreen extends StatelessWidget {
  final String userName;
  var invoices;

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

          invoices = snapshot.data!.docs;
          var productData;
          invoices.sort((a, b) {
            double dateA = (a.data() as Map<String,
                dynamic>)['Total Remaining Prices'];
            double dateB = (b.data() as Map<String,
                dynamic>)['Total Remaining Prices'];
            return dateB.compareTo(dateA); // Sort in descending order
          });
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
              double remainingPrice = idInvoices.fold(0, (sum, doc) {
                productData = doc.data() as Map<String, dynamic>;
                return sum +
                    (productData['Price Remaining'] / idInvoices.length ?? 0);
              });
              return Card(
                color: Colors.black87,
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              for (var doc in idInvoices) {
                                await doc.reference.delete();
                              }
                            },
                          ),
                        ],
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
                            title: 'User Id:        ',
                            color: Colors.green,
                            size: 18,
                          ),
                          TextWidget(
                            title: productData['User ID'],
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
                            title: 'Invoice ID',
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
                                        .toStringAsFixed(2)}',
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
                                    .toStringAsFixed(2)}',
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
                                title: '\£${productData['Price After Discount']}'
                                    .toString(),
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                          Divider(color: Colors.white),
                          Row(
                            children: [
                              TextWidget(
                                title: 'Price Paid',
                                color: Colors.white,
                                size: 16,
                              ),
                              Spacer(),
                              TextWidget(
                                title: '\£${productData['Price Paid']
                                    .toStringAsFixed(2)}',
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextWidget(
                                title: 'Remaining Price for this',
                                color: Colors.white,
                                size: 16,
                              ),
                              Spacer(),
                              TextWidget(
                                title: '\£${remainingPrice.toStringAsFixed(2)}',
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                          Divider(color: Colors.white,),
                          Row(
                            children: [
                              TextWidget(
                                title: 'Total Remaining Prices all',
                                color: Colors.white,
                                size: 16,
                              ),
                              Spacer(),
                              TextWidget(
                                title: '\£${productData['Total Remaining Prices']
                                    .toStringAsFixed(2)}',
                                color: productData['Total Remaining Prices'] <
                                    0.0 ? Colors.white : Colors.red,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Divider(color: Colors.white),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: TextWidget(
                          title: 'Thanks For shopping',
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Elevated_button(
                                text: 'Generate PDF',
                                color: Colors.red,
                                backcolor: Colors.white,
                                radius: 10,
                                padding: 10,
                                width: 120,
                                height: 40,
                                path: () {
                                  _generatePdfForInvoice(
                                      context, idInvoices, userName);
                                }
                            ),
                          ),
                        ],
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

  Future<void> _generatePdfForInvoice(BuildContext context,
      List<QueryDocumentSnapshot> idInvoices, String userName) async {
    final pdf = pw.Document();
    var productData = idInvoices.first.data() as Map<String, dynamic>;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Brand Way Food Ltd', style: pw.TextStyle(fontSize: 20)),
              pw.Text(
                  'Invoice of $userName', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Text('Date: ${productData['Date']}'),
              pw.Text('Address: ${productData['Address']}'),
              pw.SizedBox(height: 10),
              pw.Text('User Id: ${productData['User ID']}'),
              pw.SizedBox(height: 10),
              pw.Text('Product Id: ${productData['Product id']}'),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Product Name'),
                  pw.Text('Quantity'),
                  pw.Text('Total Price'),
                ],
              ),
              pw.Divider(),
              pw.Column(
                children: idInvoices.map((doc) {
                  var productData = doc.data() as Map<String, dynamic>;
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('${productData['Product Name']}'),
                      pw.Text('${productData['Selected quantity']}'),
                      pw.Text('£${productData['Total Price'].toStringAsFixed(
                          2)}'),
                    ],
                  );
                }).toList(),
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Price'),
                  pw.Text(
                      '£${productData['Price Before Discount'].toStringAsFixed(
                          2)}'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Discount'),
                  pw.Text('${productData['Discount'].toString()}%'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Payable Price'),
                  pw.Text('£${productData['Price After Discount'].toString()}'),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Price Paid'),
                  pw.Text('£${productData['Price Paid'].toStringAsFixed(2)}'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Remaining Price'),
                  pw.Text(
                      '£${productData['Price Remaining'].toStringAsFixed(2)}'),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total All Remaining Price'),
                  pw.Text(
                      '£${productData['Total Remaining Prices'].toStringAsFixed(
                          2)}'),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 30),
              pw.Center(
                child: pw.Text('Thanks For Shopping',
                    style: pw.TextStyle(fontSize: 20)),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}