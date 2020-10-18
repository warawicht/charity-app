import 'package:charityapp/services/authentication.dart';
import 'package:charityapp/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charityapp/constants.dart';

class LoginSignupScreen extends StatefulWidget {
  LoginSignupScreen({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  static const String id = 'login_signup_screen';
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          alertUser('User Signed up',
              'You are successfully signed up! Please sign in to continue.');
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void alertUser(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                toggleFormMode();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Charity App',
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
            SystemNavigator.pop();
          },
        ),
      ),
      body: Stack(
        children: [
          _showForm(),
          _showCircularProgress(),
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

  Widget _showForm() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: _formKey,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            showFormHeader(),
            showEmailInput(),
            showPasswordInput(),
            showWarningMessage(),
            showPrimaryButton(),
            showSecondaryButton(),
            showErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.center,
        autofocus: false,
        onTap: () {
          setState(() {
            _isLoading = false;
          });
        },
        style: TextStyle(fontSize: 15.0, color: Colors.white),
        decoration: kTextFieldDecoration.copyWith(
          hintText: 'Email'
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        obscureText: true,
        textAlign: TextAlign.center,
        onTap: () {
          setState(() {
            _isLoading = false;
          });
        },
        decoration: kTextFieldDecoration.copyWith(
          hintText: 'Password'
        ),
        validator: (value) {
          if (value.isEmpty && !_isLoginForm) return 'Password can\'t be empty';

          if (value.length < 8 && !_isLoginForm)
            return 'Password length must be greater than 8';

          return null;
        },
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget showFormHeader() {
    return Column(
      children: [
        SizedBox(height: 50),
        Container(
          padding: EdgeInsets.all(5),
          height: 40,
          child: Text(
            _isLoginForm ? 'Charity App Signin' : 'Charity App Signup',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          height: 90,
          child: Text(
            'Offer something for free(e.g. meal, clothes) or express what you want',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 19,
            ),
          ),
        ),
      ],
    );
  }

  Widget showWarningMessage() {
    return Column(
      children: [
        SizedBox(height: 70),
        Container(
          width: 250,
          alignment: Alignment.center,
          child: Text(
            '* By proceeding you also agree to the Terms of Service and Privacy Policy.',
          ),
        ),
        SizedBox(height: 20)
      ],
    );
  }

  Widget showPrimaryButton() {
    return CustomButton(
        buttonName: _isLoginForm ? 'SIGN IN' : 'SIGN UP',
        onPressed: validateAndSubmit);
  }

  Widget showSecondaryButton() {
    return FlatButton(
      child: Text(
        _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
      ),
      onPressed: toggleFormMode,
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }
}

