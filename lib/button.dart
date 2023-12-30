import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  const MyButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 130,
        child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(title,
                style: const TextStyle(fontSize: 16, color: Colors.black))));
  }
}
