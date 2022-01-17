import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:truco/ui/cont_page.dart';
import 'package:truco/ui/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: HomePage(),
  ));
}