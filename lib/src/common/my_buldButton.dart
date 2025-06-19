import 'package:flutter/material.dart';

buildButton({required String texto, required VoidCallback onCliked}) =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        minimumSize: Size(250, 50),
      ),
      onPressed: onCliked,
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
