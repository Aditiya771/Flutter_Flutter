import 'package:flutter/material.dart';
import 'package:pencatat_uang/homepage.dart';
import 'package:pencatat_uang/data/repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Repository.loadMemoryData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage() 
    );
  }
}