class Hole{
  int? holeNum;
  int? par;
  int? distance;
  Hole({this.holeNum, this.par, this.distance});
  Hole.fromJson(Map<String, dynamic> json):
    holeNum = json['holeNum'],
    par = json['par'],
    distance = json['distance'];
}