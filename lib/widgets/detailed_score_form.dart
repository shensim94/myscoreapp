import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:scorecardapp/models/hole_score.dart';
import '../models/course_score.dart';
import '../models/course.dart';
import '../models/haversine.dart';

class DetailedScoreForm extends StatefulWidget{
  bool hasCourse;
  Course? course;
  int holeIndex;
  CourseScore courseScore;
  DetailedScoreForm({Key? key, required this.hasCourse, this.course, required this.courseScore, required this.holeIndex}) : super(key: key);
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

  @override
  void initState() {
    isRecording = false;
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
    return Card(
      margin:const EdgeInsets.all(3),
      color:const Color.fromARGB(255, 236, 223, 195),
      child:Padding(
        padding: const EdgeInsets.all(5),
        child:Form(
        key:formKey,
        child: Column(
          children: [
            scoreCardHeader(),
            distanceForm(context),
            scoreForm(context),
            fairwayCheckBox(context),
            greenCheckBox(context),
            puttForm(context),
          ],
        ),
      )
    ));
  }

  ////////////////
  /// WIDGETS ////
  ////////////////

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
      initialValue: holeScore.strokes != null? holeScore.strokes.toString():null,
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
        });
      },
    );
  }
  
  ////////////////
  /// METHODS ////
  ////////////////
  
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
}