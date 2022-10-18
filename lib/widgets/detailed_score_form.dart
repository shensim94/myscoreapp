import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:scorecardapp/models/hole_score.dart';
import '../models/course_score.dart';
import '../models/course.dart';

class DetailedScoreForm extends StatefulWidget{
  bool hasCourse;
  Course course;
  int holeIndex;
  CourseScore courseScore;
  DetailedScoreForm({Key? key, required this.hasCourse, required this.course, required this.courseScore, required this.holeIndex}) : super(key: key);
  @override
  State<DetailedScoreForm> createState() => _DetailedScoreFormState();
}

class _DetailedScoreFormState extends State<DetailedScoreForm> {
  late HoleScore holeScore;
  late bool isChecked;
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
            decoration: const InputDecoration(hintText: "Enter score"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          CheckboxListTile(
            title: const Text("Fairway hit"),
            value: holeScore.fairway,
            onChanged: (bool? value) {
              setState(() {
                holeScore.fairway = value!;
                //isChecked = value;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("Green hit"),
            value: holeScore.green,
            onChanged: (bool? value) {
              setState(() {
                holeScore.green = value!;
                //isChecked = value;
              });
            },
          ),
          TextFormField(
            onChanged: (value) {
              int putts = int.parse(value);
              holeScore.putts=putts;
            },
            initialValue: holeScore.putts != null ? holeScore.putts.toString():null,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(hintText: "Enter number of putts"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ],
      ),
    );
  }
}