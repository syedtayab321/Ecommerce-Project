import 'package:flutter/material.dart';
class AddToCartPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                title: Text(
                  'values',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Quantity:'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '76565',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Total: 200',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
