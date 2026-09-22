import 'package:flutter/material.dart';
import 'package:trace_design/trace_design.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: TraceTypography.english.fontFamily),
      home: const Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
