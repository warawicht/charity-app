import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({this.buttonName, this.onPressed});
  final String buttonName;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(59.0),
      ),
      onPressed: onPressed,
      color: Color(0xFF42906A),
      textColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 60, vertical: 20),
        child: Text(
          buttonName.toUpperCase(),
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
