import 'package:flutter/material.dart';
import '../widgets/entry_lists.dart';
import 'select_course2.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Score Card',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(title: const Text('My Score Card'), centerTitle: true,),
          body: const Padding(padding: EdgeInsets.all(2),child:EntryLists()),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Click here to record a new round',
            child: const Icon(Icons.add),
            onPressed: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>SelectCourse2())
              );
            }
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
    );
  }
}