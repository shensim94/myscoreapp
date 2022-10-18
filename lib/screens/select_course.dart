import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'score_card.dart';
import '../models/course.dart';

class SelectCourse extends StatefulWidget{
  SelectCourse({Key? key}) : super(key: key);

  @override
  State<SelectCourse> createState() => _SelectCourseState();
}

class _SelectCourseState extends State<SelectCourse> {
  late Course course;
  int? selectValue;
  Future loadCourse() async{
    var data = await rootBundle.loadString("assets/courses/pebblebeach.json");
    var mapData = json.decode(data);
    print(mapData);
    setState(() {
      course = Course(mapData);
    });
    
  }

  void initState(){
    loadCourse();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Select Course")
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Please select the course you are playing today"),
            DropdownButtonFormField(
              value:selectValue,
              items: [
                const DropdownMenuItem(value:1, child:Text("Pebble Beach")),
                const DropdownMenuItem(value:2, child:Text("Pinehurst")),
                const DropdownMenuItem(value:3, child:Text("Torre Pines")),
              ], 
              decoration: InputDecoration(labelText: 'Course', border: OutlineInputBorder()),
              onChanged: (value){
                setState(() {
                });
              }
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>ScoreCard(hasCourse:true, course: course,))
                    );
                  },
                  child: const Text("Start Round")
                ),
                Tooltip(
                  message: 'Continue to record my round without any course data',
                  child:ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>ScoreCard(hasCourse:false, course: course,))
                      );
                    },
                    child: const Text("Proceed with Generic Card")
                  )
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}