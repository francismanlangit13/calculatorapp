import 'package:flutter/material.dart';

/*
  calling the variable to main.dart buttonText.
 */
typedef void CalculatorButtonTapCallback({String buttonText});

class CalculatorButton extends StatelessWidget {
  CalculatorButton({this.text, @required this.onTap});

  final String text;
  final CalculatorButtonTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                width: 0.5,
              ),
            ),
            child: TextButton(
              onPressed: () => onTap(buttonText: text),
              child: Text(
                text,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
              ),
            )
        )
    );
  }
}