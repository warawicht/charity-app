import 'package:charityapp/models/donation.dart';
import 'package:charityapp/models/request.dart';
import 'package:charityapp/screens/recipient_screen.dart';
import 'package:charityapp/screens/user_card.dart';
import 'package:charityapp/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemDetails extends StatelessWidget {
  ItemDetails({this.request, this.donation, this.type});
  final Donation donation;
  final Request request;
  final String type;

  String getName() {
    if (type == 'donation' || type == 'mydonation') return donation.name;
    return request.name;
  }

  String getQuantity() {
    if (type == 'donation' || type == 'mydonation') return donation.quantity;
    return request.quantity;
  }

  String getBtnName() {
    if (type == 'donation')
      return 'Contact Donor';
    else if (type == 'mydonation') return 'Go Back';
    return 'Contact Recipient';
  }

  String getDescription() {
    print(request.description);
    return request.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Item Details',
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
            Navigator.pushNamed(context, RecipientScreen.id);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                title: Text(
                  'Item Name - ' + getName().toUpperCase(),
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              )),
          Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                title: Text(
                  'Quantity - ' + getQuantity(),
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              )),
          SizedBox(height: 30),
          type == 'donation' || type == 'mydonation'
              ? Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        donation.img,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Text(getDescription(), style: TextStyle(color: Colors.teal.shade900, fontSize: 15),),
                  ),
                ),
          SizedBox(height: 50),
          CustomButton(
            buttonName: getBtnName(),
            onPressed: () {
              if (type == 'donation') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserCard(
                      name: donation.donorName,
                      address: donation.donorAddress,
                      email: donation.donorID,
                      phone: donation.donorContact,
                    ),
                  ),
                );
              } else if (type == 'mydonation') {
                Navigator.pop(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserCard(
                      name: request.recipientName,
                      address: request.recipientAddress,
                      email: request.recipientID,
                      phone: request.recipientContact,
                    ),
                  ),
                );
              }
            },
          ),
          SizedBox(height: 100)
        ],
      ),
    );
  }
}
