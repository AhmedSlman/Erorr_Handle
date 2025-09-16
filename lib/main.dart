import 'package:flutter/material.dart';
import 'views/error_explanation_view.dart';

void main() {
  runApp(const ErrorHandlerApp());
}

class ErrorHandlerApp extends StatelessWidget {
  const ErrorHandlerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Error Handler Reference',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ErrorExplanationView(),
    );
  }
}
