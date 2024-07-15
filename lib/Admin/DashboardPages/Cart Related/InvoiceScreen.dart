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
                                title: '\£${productData['Price After Discount']}'
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
          _generatePdf(context, invoices.docs);
        },
        child: Icon(Icons.picture_as_pdf),
      ),
    );
  }

  void _generatePdfForInvoice(BuildContext context,
      List<QueryDocumentSnapshot> idInvoices, String userName) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.poppinsRegular();

    var productData = idInvoices.first.data() as Map<String, dynamic>;
    String productId = productData['Product id'];

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice', style: pw.TextStyle(
                  fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Brand Way Food Ltd', style: pw.TextStyle(
                  fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text('Name: ', style: pw.TextStyle(
                      color: PdfColors.green, fontSize: 18)),
                  pw.Text(userName, style: pw.TextStyle(fontSize: 18)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text('Address: ', style: pw.TextStyle(
                      color: PdfColors.green, fontSize: 18)),
                  pw.Text(productData['Address'],
                      style: pw.TextStyle(fontSize: 18)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text('Date: ', style: pw.TextStyle(
                      color: PdfColors.green, fontSize: 18)),
                  pw.Text(
                      productData['Date'], style: pw.TextStyle(fontSize: 18)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text('Product Id: ', style: pw.TextStyle(
                      color: PdfColors.green, fontSize: 18)),
                  pw.Text(productId, style: pw.TextStyle(fontSize: 15)),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Product Name', style: pw.TextStyle(fontSize: 16)),
                  pw.Text('Quantity', style: pw.TextStyle(fontSize: 16)),
                  pw.Text('Total Price', style: pw.TextStyle(fontSize: 16)),
                ],
              ),
              pw.Divider(),
              for (var doc in idInvoices)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${doc['Product Name']}',
                        style: pw.TextStyle(fontSize: 16)),
                    pw.Text('${doc['Selected quantity']}',
                        style: pw.TextStyle(fontSize: 16)),
                    pw.Text('\£${doc['Total Price']}',
                        style: pw.TextStyle(fontSize: 16)),
                  ],
                ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Price', style: pw.TextStyle(fontSize: 16)),
                  pw.Text('\£${productData['Price Before Discount']}',
                      style: pw.TextStyle(fontSize: 16)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Discount', style: pw.TextStyle(fontSize: 16)),
                  pw.Text('${productData['Discount']}%',
                      style: pw.TextStyle(fontSize: 16)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Payable Price', style: pw.TextStyle(fontSize: 16)),
                  pw.Text('\£${productData['Price After Discount']}',
                      style: pw.TextStyle(fontSize: 16)),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Thanks for Shopping!!!!!',
                  style: pw.TextStyle(fontSize: 20)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  void _generatePdf(BuildContext context,
      List<QueryDocumentSnapshot> invoices) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.poppinsRegular();

    // Group invoices by product ID for the PDF
    Map<String, List<QueryDocumentSnapshot>> groupedInvoices = {};
    for (var doc in invoices) {
      var productData = doc.data() as Map<String, dynamic>;
      String productId = productData['User Name'];

      if (!groupedInvoices.containsKey(productId)) {
        groupedInvoices[productId] = [];
      }
      groupedInvoices[productId]!.add(doc);
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice', style: pw.TextStyle(
                  fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              ...groupedInvoices.entries.map((entry) {
                String productId = entry.key;
                List<QueryDocumentSnapshot> idInvoices = entry.value;

                double totalCostForId = idInvoices.fold(0, (sum, doc) {
                  var productData = doc.data() as Map<String, dynamic>;
                  return sum + (productData['Total Price'] ?? 0);
                });

                var productData = idInvoices.first.data() as Map<String,
                    dynamic>;

                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Brand Way Food Ltd',
                        style: pw.TextStyle(fontSize: 20, fontWeight: pw
                            .FontWeight.bold)),
                    pw.SizedBox(height: 16),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Text('Name: ', style: pw.TextStyle(
                            color: PdfColors.green, fontSize: 18)),
                        pw.Text(userName, style: pw.TextStyle(fontSize: 18)),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Text('Address: ', style: pw.TextStyle(
                            color: PdfColors.green, fontSize: 18)),
                        pw.Text(productData['Address'],
                            style: pw.TextStyle(fontSize: 18)),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Text('Date: ', style: pw.TextStyle(
                            color: PdfColors.green, fontSize: 18)),
                        pw.Text(productData['Date'],
                            style: pw.TextStyle(fontSize: 18)),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Product Id: ',
                            style: pw.TextStyle(fontSize: 18)),
                        pw.Text(productId, style: pw.TextStyle(fontSize: 15)),
                      ],
                    ),
                    pw.Divider(),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Text('Product Name',
                            style: pw.TextStyle(fontSize: 16)),
                        pw.Spacer(),
                        pw.Text('Quantity', style: pw.TextStyle(fontSize: 16)),
                        pw.Spacer(),
                        pw.Text('Total Price',
                            style: pw.TextStyle(fontSize: 16)),
                      ],
                    ),
                    pw.Divider(),
                    pw.ListView.builder(
                      itemCount: idInvoices.length,
                      itemBuilder: (context, index) {
                        var productData = idInvoices[index].data() as Map<
                            String,
                            dynamic>;
                        return pw.Row(
                          children: [
                            pw.Text('${productData['Product Name']}',
                                style: pw.TextStyle(fontSize: 16)),
                            pw.Spacer(),
                            pw.Text('${productData['Selected quantity']}',
                                style: pw.TextStyle(fontSize: 16)),
                            pw.Spacer(),
                            pw.Text('£${productData['Total Price'].toString()}',
                                style: pw.TextStyle(fontSize: 16)),
                          ],
                        );
                      },
                    ),
                    pw.Divider(),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text('Total Price',
                                style: pw.TextStyle(fontSize: 16)),
                            pw.Spacer(),
                            pw.Text('£${productData['Price Before Discount']
                                .toString()}',
                                style: pw.TextStyle(fontSize: 16)),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Text(
                                'Discount', style: pw.TextStyle(fontSize: 16)),
                            pw.Spacer(),
                            pw.Text('${productData['Discount'].toString()}\%',
                                style: pw.TextStyle(fontSize: 16)),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Text('Payable Price',
                                style: pw.TextStyle(fontSize: 16)),
                            pw.Spacer(),
                            pw.Text('£${productData['Price After Discount']
                                .toString()}',
                                style: pw.TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(16.0),
                      child: pw.Text('Thanks for Shopping',
                          style: pw.TextStyle(fontSize: 20, fontWeight: pw
                              .FontWeight.bold)),
                    ),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
