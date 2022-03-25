import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String message,bool
error =
false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,
    style: TextStyle(color: error ? Colors.red[900] : Colors.green[900]),),
      backgroundColor: error ? Colors.red[50] : Colors.green[50],));
}