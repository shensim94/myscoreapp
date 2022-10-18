import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class App extends StatelessWidget {

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Scorecard App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes:{
          '/home':(context) => const HomeScreen()
        },
        home: const HomeScreen()
    );
  }
}