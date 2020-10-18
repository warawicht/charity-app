import 'dart:io';
import 'package:charityapp/constants.dart';
import 'package:charityapp/models/donation.dart';
import 'package:charityapp/screens/root_page.dart';
import 'package:charityapp/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

FirebaseUser loggedInUser;

class DonationForm extends StatefulWidget {
  static const String id = 'donation_form';
  @override
  _DonationFormState createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  File _imageFile;
  String _uploadedImageURL;
  String _itemName;
  String _quantity;
  String _donorName;
  String _contactNumber;
  String _address;
  bool _isLoading;
  Donation _donation;

  @override
  void initState() {
    _isLoading = false;
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

  Future uploadImage() async {
    String fileName = Path.basename(_imageFile.path);
    StorageReference reference =
        FirebaseStorage.instance.ref().child('images').child(fileName);
    StorageUploadTask uploadTask = reference.putFile(_imageFile, StorageMetadata(contentType: 'image/jpeg'));
    await uploadTask.onComplete;
    print('File Uploaded');
    String downloadURL = (await (await uploadTask.onComplete).ref.getDownloadURL()).toString();
    setState(() {
      _uploadedImageURL = downloadURL;
    });
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    setState(() {
      _isLoading = false;
    });
    alertUser('Alert', 'Some of the fields are Empty!');
    _formKey.currentState.reset();
    return false;
  }

  void validateAndSubmit() async {
    if (_imageFile == null) {
      alertUser('Alert', 'No image selected.');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    if (validateAndSave()) {
      try {
        await uploadImage();
        if(_uploadedImageURL == null) {
          alertUser('Error', 'Some error occurred while uploading image');
          setState(() {
            _isLoading = false;
            _imageFile = null;
          });
          _formKey.currentState.reset();
          return;
        }
        print(_uploadedImageURL);
        _donation = Donation(
          donorName: _donorName,
          donorAddress: _address,
          donorContact: _contactNumber,
          donorID: loggedInUser.email,
          name: _itemName,
          quantity: _quantity,
          img: _uploadedImageURL,
        );
        await _db.collection('donations').add(_donation.toJSON());
        setState(() {
          _isLoading = false;
          _imageFile = null;
        });
        alertUser('Success', 'Thank you for making a donation!');
        _formKey.currentState.reset();
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _imageFile = null;
        });
        alertUser('Error', e.message);
        _formKey.currentState.reset();
      }
    }
  }

  Future getImage(bool isCamera) async {
    PickedFile image;
    if (isCamera) {
      image = await ImagePicker().getImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker().getImage(source: ImageSource.gallery);
    }
    setState(() {
      _imageFile = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Donation Form',
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
            Navigator.pushNamed(context, RootPage.id);
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
                  'Add an item to the donation list',
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
                    showFormField('Donor Name', 3),
                    showFormField('Contact Number', 4),
                    showFormField('Location', 5),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          _imageFile == null ? 'Choose Photo' : 'Change photo',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _imageFile == null
                                  ? Colors.white
                                  : Colors.blueAccent,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: () {
                            getImage(true);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add_photo_alternate),
                          onPressed: () {
                            getImage(false);
                          },
                        ),
                      ],
                    ),
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
    if (_isLoading) {
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
        decoration: kTestFieldDecorationForOneSidedBorders.copyWith(
          hintText: name
        ),
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
              _donorName = value;
              break;
            case 4:
              _contactNumber = value;
              break;
            case 5:
              _address = value;
              break;
          }
        },
      ),
    );
  }
}