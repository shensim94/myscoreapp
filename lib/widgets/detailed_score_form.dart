import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:scorecardapp/models/hole_score.dart';
import '../models/course_score.dart';
import '../models/course.dart';
import '../models/haversine.dart';

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
  late bool isRecording;
  LocationData? locationData1;
  LocationData? locationData2;
  int? distance;
  Location location= Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  /* retrieves the location */
  Future retrieveLocation() async {
    
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    LocationData tempData = await location.getLocation();
    return tempData;
  }


  @override
  void initState() {
    // TODO: implement initState
    isRecording = false;
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
          distanceForm(context),
          scoreForm(context),
          fairwayCheckBox(context),
          greenCheckBox(context),
          puttForm(context),
        ],
      ),
    );
  }

  Widget distanceForm(BuildContext context){
    return Row(
      children: [
        SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: ()async{
                LocationData currentLocation = await retrieveLocation();
                if(!isRecording){
                  setState((){
                    locationData1 = currentLocation;
                    isRecording=true;
                  });
                }else{
                  setState((){
                    locationData2 = currentLocation;
                    holeScore.driveDist = Haversine(locationData1!.latitude, locationData1!.longitude, locationData2!.latitude, locationData2!.longitude);
                    isRecording=false;
                  });
                }
              },
              child: isRecording? Text('Stop Recording'): Text('Record Drive'),
            )
        ),
        holeScore.driveDist!=null? Text('${holeScore.driveDist} yards'):Text('')
      ],
    );
  }

  Widget scoreForm(BuildContext context){
    return TextFormField(
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
    );
  }

  Widget puttForm(BuildContext context){
    return TextFormField(
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
    );
  }

  Widget fairwayCheckBox(BuildContext context){
    return CheckboxListTile(
      title: const Text("Fairway hit"),
      value: holeScore.fairway,
      onChanged: (bool? value) {
        setState(() {
          holeScore.fairway = value!;
          //isChecked = value;
        });
      },
    );
  }

  Widget greenCheckBox(BuildContext context){
    return CheckboxListTile(
      title: const Text("Green hit"),
      value: holeScore.green,
      onChanged: (bool? value) {
        setState(() {
          holeScore.green = value!;
          //isChecked = value;
        });
      },
    );
  }
}