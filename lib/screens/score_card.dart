import 'package:flutter/material.dart';
import '../widgets/score_form.dart';
import '../models/course_score.dart';
import '../models/course.dart';
import 'package:intl/intl.dart';
import '../widgets/detailed_score_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class ScoreCard extends StatefulWidget{

  bool hasCourse;
  Course? course;
  ScoreCard({Key? key, required this.hasCourse, this.course}) : super(key: key);

  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {

  CourseScore scores = CourseScore();
  bool isDetailed = false;

  
  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar:AppBar(
        leading: const BackButton(),
        centerTitle: true,
        title: widget.hasCourse? Text(widget.course!.name!): const Text('Unknown Course'),
      ),

      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[customExpanded(), myToolTip()]
      ),

      endDrawer: scoreCardDrawer()
    );
  }

  ////////////////
  /// WIDGETS ////
  ////////////////

  /*Drawer containing the toggle to enable detailed stats*/
  Widget scoreCardDrawer(){
    return Drawer(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 80,
            width: double.infinity,
            child: DrawerHeader(child: Text('Settings')),
          ),
          SwitchListTile(
            title: const Text('Enable Detailed Stats'),
            value: isDetailed,
            onChanged: (bool value) {
              setState(() {
                isDetailed? isDetailed=false: isDetailed=true;
              });
            }
          ),
        ],
      )
    );
  }

  /*Expanded Widget containing the pageview widgets*/
  Widget customExpanded(){
    return Expanded(
      child:PageView.builder(
        itemCount: 18,
        itemBuilder: ((context, index) {
          return isDetailed?
          DetailedScoreForm(hasCourse:widget.hasCourse, course: widget.course, courseScore:scores, holeIndex: index):
          ScoreForm(hasCourse:widget.hasCourse, course: widget.course, courseScore:scores, holeIndex: index);
        }),
      )
    );
  }

  /*let user know the cost of uploading*/
  Widget myToolTip(){
    return Tooltip(
      message: 'Upload score, may consume cellular data',
      child: ElevatedButton(
        onPressed: (){
          isCardComplete()? uploadScore(): alertUser();
        },
        child: const Text('Submit Score')
      ),
    );
  }


  ////////////////
  /// METHODS ////
  ////////////////

  String getDate() {
    DateTime now = DateTime.now();
    //print(FieldValue.serverTimestamp());
    var formatter = DateFormat('EEEE, MMM d, yyyy');
    return formatter.format(now);
  }

  /*warn user before they upload incomplete scorecards*/
  void alertUser(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Alert"),
          content: const Text("You may have an incomplete score card"),
          actions: [
            TextButton(child:const Text('cancel'), onPressed: (){Navigator.pop(context);}),
            TextButton(child:const Text('upload anyways'), onPressed: (){Navigator.pop(context); uploadScore();}),
          ]
        );
      }
    );
  }

  /* used to trigger alert*/
  bool isCardComplete(){
    for (var e in scores.scores){
      if(e.strokes==null){
        return false;
      }
    }
    return true;
  }

  /* uploads to firestore as a document, document id is auto generated*/
  void uploadScore(){
    FirebaseFirestore.instance.collection('scores').add(
      {
        'date':getDate(),
        'course':widget.course==null? "unknown": widget.course!.name,
        'scores':scores.toMap(),
        'created':FieldValue.serverTimestamp()
      }
    );
    Navigator.pushNamed(context, '/home');
  }
}