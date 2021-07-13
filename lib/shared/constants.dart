import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.blueGrey,
  hintStyle: TextStyle(color: Colors.grey),
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orangeAccent, width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orangeAccent, width: 2.0)),
);
