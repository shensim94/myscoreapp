import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'score_card.dart';
import '../models/course.dart';
import '../models/my_search_delegate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectCourse2 extends StatefulWidget{
  const SelectCourse2({Key? key}) : super(key: key);

  @override
  State<SelectCourse2> createState() => _SelectCourse2State();
}

class _SelectCourse2State extends State<SelectCourse2> {
  late Course course;
  late List<String> courses;
  String courseName = "";

  void initState(){
    loadSearchTerms();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Search Course"),
        actions: [myIconButton()],
      ),
      body: Center(
        child: Card(
          color: const Color.fromARGB(255, 236, 223, 195),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding:EdgeInsets.all(30),
                child:Text("Please select the course you are playing today",
                  style: TextStyle(fontFamily:'RobotoSlab', fontSize:20)
                )
              ),
              SizedBox(
                height:40, 
                child:Text(
                  courseName,
                  style: const TextStyle(fontFamily:'RobotoSlab', fontSize:20, color: Colors.blue)
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [startRoundButton(), const SizedBox(width:10), genericCourseButton()],
              )
            ],
          )
        ),
      )
    );
  }

  ////////////////
  /// WIDGETS ////
  ////////////////

  Widget myIconButton(){
    return IconButton(
      onPressed: () async {
        String searchResult = await showSearch(
          context: context,
          delegate: MySearchDelegate(searchTerms: courses)
        );
        setState(() {
          courseName = searchResult;
        });
        loadCourse();
      },
      icon: const Icon(Icons.search)
    );
  }

  Widget startRoundButton(){
    return ElevatedButton(
      onPressed: (){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>ScoreCard(hasCourse:true, course: course,))
        );
      },
      child: const Text("Start Round")
    );
  }

  Widget genericCourseButton(){
    return Tooltip(
      message: 'Continue to record my round without any course data',
      child:ElevatedButton(
        onPressed: (){
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>ScoreCard(hasCourse:false))
          );
        },
        child: const Text("Proceed with Generic Card")
      )
    );
  }

  ////////////////
  /// METHODS ////
  ////////////////

  Future loadCourse() async{
    var data = await FirebaseFirestore.instance.collection('courses').doc(courseName).get();
    print(data['name']);
    setState(() {
      course = Course(data);
    });
  }

  Future loadSearchTerms() async{
    List<String> temp=[];
    var data = await rootBundle.loadString("assets/courses/searchterms.json");
    var mapData = json.decode(data);
    for (var e in mapData['courses']){
      temp.add(e);
    }
    setState(() {courses = temp;});
  }
}