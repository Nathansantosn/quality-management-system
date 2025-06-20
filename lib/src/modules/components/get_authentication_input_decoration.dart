import 'package:flutter/material.dart';

InputDecoration getAuthenticationInputDecoration(
  String label, {
  Icon? icon,
  IconButton? suffixIcon,
}) {
  return InputDecoration(
    icon: icon,
    hintText: label,
    fillColor: Colors.white,
    filled: true,
    suffixIcon: suffixIcon,
    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: Colors.blue),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: Colors.red),
    ),
  );
}
