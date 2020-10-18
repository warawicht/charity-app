import 'package:charityapp/constants.dart';
import 'package:charityapp/models/request.dart';
import 'package:charityapp/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseUser loggedInUser;

class RequestForm extends StatefulWidget {
  static const String id = 'request_form';
  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  bool isLoading;
  String _itemName;
  String _quantity;
  String _recipientName;
  String _contactNumber;
  String _address;
  String _description;
  Request _request;

  @override
  void initState() {
    isLoading = false;
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void alertUser(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                _formKey.currentState.reset();
              },
            )
          ],
        );
      },
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    setState(() {
      isLoading = false;
    });
    alertUser('Alert', 'Some of the fields are Empty!');
    _formKey.currentState.reset();
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      isLoading = true;
    });
    if (validateAndSave()) {
      try {
        _request = Request(
            name: _itemName,
            quantity: _quantity,
            recipientName: _recipientName,
            recipientContact: _contactNumber,
            recipientAddress: _address,
            description: _description,
            recipientID: loggedInUser.email);
        await _db.collection('requests').add(_request.toJSON());
        setState(() {
          isLoading = false;
        });
        alertUser('Success', 'Your Request has been made.');
        _formKey.currentState.reset();
      } catch (e) {
        print('Error: $e');
        setState(() {
          isLoading = false;
        });
        alertUser('Error', e.message);
        _formKey.currentState.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Request Form',
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
      body: Stack(
        children: [
          _showCircularProgress(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                width: 400,
                child: Text(
                  'Make a Request',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    showFormField('Item Name', 1),
                    showFormField('Quantity', 2),
                    showFormField('Recipient Name', 3),
                    showFormField('Contact Number', 4),
                    showFormField('Location', 5),
                    showFormField('Description', 6),
                    SizedBox(height: 70),
                    CustomButton(
                      buttonName: 'Submit',
                      onPressed: () {
                        validateAndSubmit();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _showCircularProgress() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showFormField(String name, int type) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
      child: TextFormField(
        textAlign: TextAlign.center,
        autofocus: false,
        keyboardType: type == 6 ? TextInputType.multiline : TextInputType.text,
        maxLines: type == 6 ? null : 1,
        decoration:
            kTestFieldDecorationForOneSidedBorders.copyWith(hintText: name),
        validator: (value) => value.isEmpty ? "can\'t be empty" : null,
        onSaved: (value) {
          switch (type) {
            case 1:
              _itemName = value;
              break;
            case 2:
              _quantity = value;
              break;
            case 3:
              _recipientName = value;
              break;
            case 4:
              _contactNumber = value;
              break;
            case 5:
              _address = value;
              break;
            case 6:
              _description = value;
              break;
          }
        },
      ),
    );
  }
}
