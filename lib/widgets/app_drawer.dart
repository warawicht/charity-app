import 'package:charityapp/screens/covid19_pdf_view.dart';
import 'package:charityapp/screens/donors_screen.dart';
import 'package:charityapp/screens/recipient_screen.dart';
import 'package:charityapp/screens/recipients_list_screen.dart';
import 'package:charityapp/screens/root_page.dart';
import 'package:flutter/material.dart';
import 'package:charityapp/widgets/option_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseUser loggedInUser;

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: Icon(Icons.clear),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              OptionTile(
                onTap: () {
                  Navigator.pushNamed(context, DonorScreen.id);
                },
                optionName: 'Donate',
              ),
              OptionTile(
                onTap: () {
                  Navigator.pushNamed(context, RecipientScreen.id);
                },
                optionName: 'Add Request',
              ),
              OptionTile(
                onTap: () {
                  Navigator.pushNamed(context, RecipientsList.id);
                },
                optionName: 'Check Requests',
              ),
              OptionTile(
                onTap: () {
                  Navigator.pushNamed(context, Covid19PDFView.id);
                },
                optionName: 'Covid-19 Australia',
              ),
              OptionTile(
                onTap: () {
                  _auth.signOut();
                  Navigator.pushNamed(context, RootPage.id);
                },
                optionName: 'LogOut',
              )
            ],
          ),
        ),
      ),
    );
  }
}
