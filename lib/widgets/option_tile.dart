import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  const OptionTile({@required this.onTap, @required this.optionName});
  final String optionName;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
      ),
      child: ListTile(
        title: Text(
          optionName,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white70),
        ),
        onTap: onTap,
      ),
    );
  }
}
