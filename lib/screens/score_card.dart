import 'package:flutter/material.dart';
import '../widgets/score_form.dart';
import '../models/course_score.dart';
import '../models/course.dart';
import '../widgets/detailed_score_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreCard extends StatefulWidget{
  bool hasCourse;
  Course course;
  ScoreCard({Key? key, required this.hasCourse, required this.course}) : super(key: key);

  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  CourseScore scores = CourseScore();
  bool isDetailed = false;
  bool isCardComplete(){
    for (var e in scores.scores){
      if(e.strokes==null){
        return false;
      }
    }
    return true;
  }
  void uploadScore(){
    FirebaseFirestore.instance
                .collection('scores')
                .add({'date':'insert date here', 'course':widget.course.name, 'scores':scores.toMap()});
                Navigator.pushNamed(context, '/home');
  }
  void alertUser(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Alert"),
          content: Text("You may have an incomplete score card"),
          actions: [
            TextButton(child:Text('cancel'), onPressed: (){Navigator.pop(context);}),
            TextButton(child:Text('upload anyways'), onPressed: (){Navigator.pop(context); uploadScore();}),
          ]
        );
      }
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: true,
        title: widget.hasCourse? Text(widget.course.name!): Text('Unknown Course'),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          Expanded(
            child:PageView.builder(
              itemCount: 18,
              itemBuilder: ((context, index) {
                return isDetailed?
                DetailedScoreForm(hasCourse:widget.hasCourse, course:widget.course, courseScore:scores, holeIndex: index):
                ScoreForm(hasCourse:widget.hasCourse, course: widget.course, courseScore:scores, holeIndex: index);
                //ScoreForm(courseScore: scores, holeIndex: index);
              }),
              //onPageChanged:printScores,
            )
          ),
          Tooltip(
            message: 'Upload score to the cloud, may use mobile data',
            child: ElevatedButton(
              onPressed: (){
                isCardComplete()? uploadScore(): alertUser();
              },
              child: const Text('Submit Score')
            ),
          ),
          
        ]
      ),
      endDrawer: Drawer(
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
          ),
      ),
    );
  }
}