import 'hole.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;

class Course{
  String? name;
  List<Hole>? holes;
  Course(DocumentSnapshot<Map<String, dynamic>> json){
    List<Hole> holes = [];
    for (var e in json['holes']){
      holes.add(Hole.fromJson(e));
    }
    this.name = json['name'];
    this.holes = holes;
  }
}