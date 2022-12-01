class HoleScore{
  int? holeNum;
  int? strokes;
  bool fairway;
  bool green;
  int? putts;
  int? driveDist;
  int? holeDist;
  int? holePar;
  HoleScore({this.holeNum, this.strokes, this.fairway = false, this.green = false, this.putts, this.driveDist, this.holeDist, this.holePar});
  Map<String, dynamic> toMap(){
    return {
      'holeNum':holeNum,
      'strokes':strokes,
      'fairway':fairway,
      'green':green,
      'putts':putts,
      'drive_dist':driveDist,
      'hole_dist':holeDist,
      'hole_par':holePar
    };
  }
}