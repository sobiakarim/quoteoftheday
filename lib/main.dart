import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quote_of_the_day/home_screen.dart';

void main(){
  runApp(QuotesApp());
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

