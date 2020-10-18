import 'package:charityapp/screens/root_page.dart';
import 'package:charityapp/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  UserCard({this.name, this.email, this.address, this.phone});
  final String name;
  final String address;
  final String phone;
  final String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Card',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF42906A),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 15,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column (
        children: <Widget>[
          SizedBox(height: 100),
          Text(
            name.toUpperCase(),
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            address.toUpperCase(),
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20.0,
            width: 150.0,
            child: Divider(
              color: Colors.teal.shade100,
            ),
          ),
          Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(Icons.phone, color: Colors.teal),
                title: Text(
                  phone,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white
                  ),
                ),
              )
          ),
          Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(Icons.email, color: Colors.teal),
                title: Text(
                  email,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white
                  ),
                ),
              )
          ),
          SizedBox(height: 50),
          CustomButton(
            buttonName: 'Go Back To Home',
            onPressed: () {
              Navigator.pushNamed(context, RootPage.id);
            },
          )
        ],
      )
    );
  }
}
