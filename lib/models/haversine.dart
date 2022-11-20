import 'dart:math';

int Haversine(lat1, long1, lat2, long2){
  const kmToYards = 1093.61;
  const rad = pi/180;
  lat1 = lat1*rad;
  lat2 = lat2*rad;
  long1 = long1*rad;
  long2 = long2*rad;
  var deltaLat = (lat1-lat2)/2;
  var deltaLong = (long1-long2)/2;
  var a = sin(deltaLat)*sin(deltaLat)+cos(lat1)*cos(lat2)*sin(deltaLong)*sin(deltaLong);
  var d = 2*6371*asin(sqrt(a))*kmToYards;
  return d.round();
}