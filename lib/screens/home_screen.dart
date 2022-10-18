import 'package:flutter/material.dart';
import '../widgets/entry_lists.dart';
import 'package:firebase_core/firebase_core.dart';
import 'select_course.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: EntryLists(),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Click here to record a new round',
            child: const Icon(Icons.add),
            onPressed: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>SelectCourse())
              );
            }
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
    );
  }
}