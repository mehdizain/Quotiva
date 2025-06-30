import 'package:flutter/material.dart';
InputDecoration inputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
      color: Colors.grey[600],
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    prefixIcon: Container(
      margin: EdgeInsets.only(right: 12),
      child: Icon(
        icon,
        color: Colors.indigo[700],
        size: 22,
      ),
    ),
    filled: true,
    fillColor: Colors.grey[50],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.indigo[700]!, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.red[400]!, width: 1),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
  );
}
