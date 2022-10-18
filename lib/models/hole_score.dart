class HoleScore{
  int? holeNum;
  int? strokes;
  bool fairway;
  bool green;
  int? putts;
  HoleScore({this.holeNum, this.strokes, this.fairway = false, this.green = false, this.putts});
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