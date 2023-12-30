import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;
  final double? iconSize;
  const MyIconButton(
      {super.key, required this.onPressed, required this.icon, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.grey[900]),
        child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: Colors.white, size: iconSize ?? 25)));
  }
}
