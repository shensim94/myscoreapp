class HoleScore{
  int? holeNum;
  int? strokes;
  bool fairway;
  bool green;
  int? putts;
  int? driveDist;
  HoleScore({this.holeNum, this.strokes, this.fairway = false, this.green = false, this.putts, this.driveDist});
  Map<String, dynamic> toMap(){
    return {
      'holeNum':holeNum,
      'strokes':strokes,
      'fairway':fairway,
      'green':green,
      'putts':putts
    };
  }
}