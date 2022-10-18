import 'hole_score.dart';

class CourseScore{
  String? courseName;
  DateTime? date;
  List<HoleScore> scores = List<HoleScore>.generate(18, (_) => HoleScore()); // generate a list of unique HoleScores.
  List<Map> toMap(){
    List<Map> list = [];
    for (var e in scores) {
      list.add(e.toMap());
    }
    return list;
  }
}