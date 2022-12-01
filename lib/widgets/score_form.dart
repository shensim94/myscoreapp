import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:scorecardapp/models/hole_score.dart';
import '../models/course_score.dart';
import '../models/course.dart';

class ScoreForm extends StatefulWidget{
  bool hasCourse;
  Course? course;
  int holeIndex;
  CourseScore courseScore;
  ScoreForm({Key? key, required this.hasCourse, this.course, required this.courseScore, required this.holeIndex}) : super(key: key);
  @override
  State<ScoreForm> createState() => _ScoreFormState();
}

class _ScoreFormState extends State<ScoreForm> {
  late HoleScore holeScore;

  @override
  void initState() {
    holeScore = widget.courseScore.scores[widget.holeIndex];
    holeScore.holeNum = widget.holeIndex+1;
    if (widget.hasCourse){
      holeScore.holeDist = widget.course?.holes![widget.holeIndex].distance;
      holeScore.holePar = widget.course?.holes![widget.holeIndex].par;
    }
  }


  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    return Card(margin:const EdgeInsets.all(3),
    color:const Color.fromARGB(255, 236, 223, 195),
    child:Padding(padding: EdgeInsets.all(5),
    child: Form(
      key:formKey,
      child: Column(
        children: [
          scoreCardHeader(),
          scoreForm(context)
        ],
      ),
    )));
  }

  Widget scoreForm(BuildContext context){
    return TextFormField(
      onChanged: (value) {
        print("changed");
        int score = int.parse(value);
        holeScore.strokes=score;
      },
      initialValue: holeScore.strokes != null? holeScore.strokes.toString():null,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(hintText: "Enter score"),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }

  Widget scoreCardHeader(){
    if(widget.hasCourse){
      return Column(
        children: [
          Text('Hole ${widget.course?.holes![widget.holeIndex].holeNum}'),
          Text('Par ${widget.course?.holes![widget.holeIndex].par}'),
          Text('${widget.course?.holes![widget.holeIndex].distance} Yards')
        ]
      );
    } else {
      return Column(
        children: [
          Text('Hole ${widget.holeIndex+1}'),
        ]
      );
    }
  }
}