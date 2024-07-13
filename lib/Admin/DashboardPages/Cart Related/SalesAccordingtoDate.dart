import 'package:ecommerce_app/Controllers/SalesBasedOnDateController.dart';
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
        title: Text('Sales Invoice'),
        backgroundColor: Colors.deepPurple,
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
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Product: ${sale['productName'] ?? 'N/A'}',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Quantity: ${sale['quantity'] ?? 'N/A'}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Price: \$${sale['Price After Discount'] ?? 'N/A'}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Date: ${sale['date'] ?? 'N/A'}',
                                        style: TextStyle(fontSize: 16),
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
                          'Total Cost: \$${orderController.totalCost.value}',
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
