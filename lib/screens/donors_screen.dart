import 'package:charityapp/models/donation.dart';
import 'package:charityapp/screens/donation_form.dart';
import 'package:charityapp/widgets/app_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'item_details.dart';

FirebaseUser loggedInUser;

class DonorScreen extends StatefulWidget {
  static const String id = 'donor_screen';
  @override
  _DonorScreenState createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Donation> donations;
  bool isLoading;
  String currentUserEmail;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        currentUserEmail = loggedInUser.email;
      }
    } catch (e) {
      print(e);
    }
    getDonations();
  }

  getDonations() async {
    var data = await _db
        .collection('donations')
        .where('donorID', isEqualTo: currentUserEmail)
        .getDocuments();
    print(data.documents.length);
    if (data.documents.length != 0) {
      setState(() {
        donations = data.documents
            .map((doc) => Donation.fromMap(doc.data, doc.documentID))
            .toList();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget donationCard(Donation donation) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ItemDetails(donation: donation, type: 'mydonation'),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
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
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                donation.name.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    isLoading = true;
    getCurrentUser();
    super.initState();
  }

  showCircularProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Charity App'),
        centerTitle: true,
        backgroundColor: Color(0xFF42906A),
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? showCircularProgress()
          : SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Donations',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: Color(0xFF42906A),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, DonationForm.id);
                              },
                              iconSize: 50,
                            ),
                            Text(
                              'add item',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: donations != null
                        ? GridView.builder(
                            itemCount: donations.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int i) {
                              return donationCard(donations[i]);
                            },
                          )
                        : Center(
                            child: Text(
                              'No Donations has been made by you',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
