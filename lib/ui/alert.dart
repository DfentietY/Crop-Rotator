import 'package:flutter/material.dart';

class Alert extends AlertDialog {
  Alert({this.title, this.body, @required this.function, this.error = false});

  final title;
  final body;
  final function;
  final error;

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle(
      color: Colors.white,
    );
    return (!error)
        ? AlertDialog(
            backgroundColor: Colors.black,
            contentTextStyle: _textStyle,
            title: title,
            content: body,
            actions: <Widget>[
              AlertButton(
                text: 'Close',
                function: () => Navigator.of(context).pop(),
              ),
              AlertButton(function: function),
            ],
          )
        : AlertDialog(
            backgroundColor: Colors.black,
            contentTextStyle: _textStyle,
            title: title,
            content: body,
            actions: <Widget>[
              AlertButton(
                text: 'Close',
                function: () => Navigator.of(context).pop(),
              ),
            ],
          );
  }
}

class AlertButton extends StatelessWidget {
  AlertButton({
    this.text = 'Accept',
    @required this.function,
  });

  final text;
  final function;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: function,
      child: Text(text),
    );
  }
}
