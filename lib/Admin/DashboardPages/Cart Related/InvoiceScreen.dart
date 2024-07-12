import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final invoices = await FirebaseFirestore.instance
              .collection('Orders')
              .doc(userCnic)
              .collection('Buyed Products')
              .get();
          _generatePdf(context, invoices.docs);
        },
        child: Icon(Icons.picture_as_pdf),
      ),
    );
  }

  void _generatePdf(BuildContext context, List<QueryDocumentSnapshot> invoices) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.poppinsRegular();

    // Group invoices by date for the PDF
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

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              ...groupedInvoices.entries.map((entry) {
                String date = entry.key;
                List<QueryDocumentSnapshot> dateInvoices = entry.value;

                double totalCostForDate = dateInvoices.fold(0, (sum, doc) {
                  var productData = doc.data() as Map<String, dynamic>;
                  return sum + (productData['Total Price'] ?? 0);
                });

                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Date: $date', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Text('Total Cost for Date: \$${totalCostForDate.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 16)),
                    pw.SizedBox(height: 10),
                    ...dateInvoices.map((doc) {
                      var productData = doc.data() as Map<String, dynamic>;
                      Timestamp timestamp = productData['Date'];
                      DateTime dateTime = timestamp.toDate();
                      String formattedTime = DateFormat('kk:mm').format(dateTime);

                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Divider(),
                          pw.Text('Product Name: ${productData['Product Name']}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                          pw.Text('CNIC: $userCnic', style: pw.TextStyle(fontSize: 16)),
                          pw.Text('Time: $formattedTime', style: pw.TextStyle(fontSize: 16)),
                          pw.Text('Total: \$${productData['Total Price']}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                          pw.Divider(),
                        ],
                      );
                    }).toList(),
                    pw.SizedBox(height: 20),
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
