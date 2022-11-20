import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:scorecardapp/models/hole_score.dart';
import '../models/course_score.dart';
import '../models/course.dart';

class ScoreForm extends StatefulWidget{
  bool hasCourse;
  Course course;
  int holeIndex;
  CourseScore courseScore;
  ScoreForm({Key? key, required this.hasCourse,required this.course, required this.courseScore, required this.holeIndex}) : super(key: key);
  @override
  State<ScoreForm> createState() => _ScoreFormState();
}

class _ScoreFormState extends State<ScoreForm> {
  late HoleScore holeScore;

  @override
  void initState() {
    // TODO: implement initState
    holeScore = widget.courseScore.scores[widget.holeIndex];
    holeScore.holeNum = widget.holeIndex+1;
  }


  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    return Form(
      key:formKey,
      child: Column(
        children: [
          widget.hasCourse? Text('Hole ${widget.course.holes![widget.holeIndex].holeNum}'):Text('Hole ${widget.holeIndex+1}'),
          widget.hasCourse? Text('Par ${widget.course.holes![widget.holeIndex].par}'):const SizedBox(width:0, height: 0,),
          widget.hasCourse? Text('${widget.course.holes![widget.holeIndex].distance} Yards'):const SizedBox(width:0, height: 0,),
          TextFormField(
            onChanged: (value) {
              print("changed");
              int score = int.parse(value);
              holeScore.strokes=score;
            },
            initialValue: holeScore.strokes != null ? holeScore.strokes.toString():null,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(hintText: "Enter Score"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (value){
              if(value!.isEmpty){
                return 'Please enter a valid number';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }
}