import 'package:ecommerce_app/Controllers/SalesBasedOnDateController.dart';
import 'package:ecommerce_app/widgets/OtherWidgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class SalesBasedOnDate extends StatelessWidget {
  final SalesOnDateController orderController = Get.put(SalesOnDateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextWidget(title: 'Sales Invoice',color: Colors.white,),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Obx(() {
            return TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              focusedDay: orderController.selectedDate.value,
              selectedDayPredicate: (day) {
                return isSameDay(orderController.selectedDate.value, day);
              },
              onDaySelected: orderController.onDateSelected,
            );
          }),
          Obx(() {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sales for ${DateFormat('yyyy-MM-dd').format(orderController.selectedDate.value)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: orderController.sales.length,
                            itemBuilder: (context, index) {
                              var sale = orderController.sales[index];
                              return Card(
                                color: Colors.black87,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        title: 'Product: ${sale['Product Name'] ?? 'N/A'}',
                                        size: 18, weight: FontWeight.bold,color: Colors.white,
                                      ),
                                      TextWidget(
                                        title: 'Quantity: ${sale['Selected quantity'] ?? 'N/A'}',
                                        size: 16,color: Colors.white,
                                      ),
                                      TextWidget(
                                        title: 'Price: \£${sale['Total Price'] ?? 'N/A'}',
                                        size: 16,color: Colors.white,
                                      ),
                                      TextWidget(
                                        title: 'Date: ${sale['Date'] ?? 'N/A'}',
                                        size: 16,color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Total Cost: \£${orderController.totalCost.value}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
