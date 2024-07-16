import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/ElevatedButton.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
              List<QueryDocumentSnapshot> idInvoices = groupedInvoices[productId]!;

              double totalCostForId = idInvoices.fold(0, (sum, doc) {
                productData = doc.data() as Map<String, dynamic>;
                return sum + (productData['Total Price'] ?? 0);
              });

              double remainingPrice = 0.0;
              for (var doc in idInvoices) {
                var productData = doc.data() as Map<String, dynamic>;
                remainingPrice += (productData['Price Remaining'] ?? 0);
              }

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
                          var productData = idInvoices[index].data() as Map<String, dynamic>;

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
                                title: '\£${productData['Price Paid'].toStringAsFixed(2)}',
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextWidget(
                                title: 'Remaining Price',
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
                          Align(
                            alignment: Alignment.topRight,
                            child: Elevated_button(
                                text: 'Update Invoice',
                                color: Colors.white,
                                backcolor: Colors.green,
                                radius: 10,
                                padding: 10,
                                width: 120,
                                height: 40,
                                path: () {
                                  _showUpdateDialog(context, idInvoices, userName);
                                }
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final invoices = await FirebaseFirestore.instance
              .collection('Orders')
              .doc(userName)
              .collection('Buyed Products')
              .get();

          if (invoices.docs.isNotEmpty) {
            _generatePdfForInvoice(context, invoices.docs, userName);
          }
        },
        child: Icon(Icons.picture_as_pdf),
      ),
    );
  }

  Future<void> _generatePdfForInvoice(BuildContext context, List<QueryDocumentSnapshot> invoices, String userName) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Invoice of ' + userName,
                style: pw.TextStyle(fontSize: 20, font: font),
              ),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                context: context,
                data: <List<dynamic>>[
                  <String>['Product Name', 'Quantity', 'Total Price'],
                  ...invoices.map((doc) {
                    var productData = doc.data() as Map<String, dynamic>;
                    return [
                      productData['Product Name'],
                      productData['Selected quantity'].toString(),
                      productData['Total Price'].toStringAsFixed(2),
                    ];
                  }).toList()
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Total Price: \£${invoices.fold<double>(0.0, (double sum, doc) {
                      var productData = doc.data() as Map<String, dynamic>;
                      return sum + (productData['Total Price'] ?? 0.0);
                    }).toStringAsFixed(2)}',
                    style: pw.TextStyle(fontSize: 16, font: font),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  void _showUpdateDialog(BuildContext context, List<QueryDocumentSnapshot> invoices, String userName) {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Remaining Price'),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter remaining price to pay'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                double remainingPrice = double.parse(_controller.text);

                for (var doc in invoices) {
                  await doc.reference.update({
                    'Price Paid': FieldValue.increment(remainingPrice),
                    'Price Remaining': FieldValue.increment(-remainingPrice),
                  });
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
