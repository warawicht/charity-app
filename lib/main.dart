import 'package:charityapp/screens/covid19_pdf_view.dart';
import 'package:charityapp/screens/donation_form.dart';
import 'package:charityapp/screens/donors_screen.dart';
import 'package:charityapp/screens/login_signup_screen.dart';
import 'package:charityapp/screens/recipient_screen.dart';
import 'package:charityapp/screens/recipients_list_screen.dart';
import 'package:charityapp/screens/request_form.dart';
import 'package:charityapp/screens/root_page.dart';
import 'package:charityapp/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Charity App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: RootPage.id,
      routes: {
        RootPage.id: (context) => RootPage(auth: Auth()),
        LoginSignupScreen.id: (context) => LoginSignupScreen(),
        DonorScreen.id: (context) => DonorScreen(),
        DonationForm.id: (context) => DonationForm(),
        RecipientsList.id: (context) => RecipientsList(),
        RecipientScreen.id: (context) => RecipientScreen(),
        RequestForm.id: (context) => RequestForm(),
        Covid19PDFView.id: (context) => Covid19PDFView(),
      },
    );
  }
}
