import 'hole.dart';

class Course{
  String? name;
  List<Hole>? holes;
  Course(Map<String, dynamic> json){
    List<Hole> holes = [];
    for (var e in json['holes']){
      holes.add(Hole.fromJson(e));
    }
    this.name = json['name'];
    this.holes = holes;
  }
}