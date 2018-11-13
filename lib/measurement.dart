const BUG_FIX_OFFSET = 500;

class Measurement {
  int position;
  int roomTemp;
  int roomHumidity;
  int inTemp;
  int outTemp;
  DateTime time;
  Duration durationBetweenThisAndNext;

  Measurement.fromJson(Map<String, dynamic> j) {
    time = DateTime.parse(j['created_at']);
    outTemp = int.parse(j['field1']);
    inTemp = int.parse(j['field2']);
    roomTemp = int.parse(j['field3']);
    roomHumidity = int.parse(j['field4']);
    position = int.parse(j['field5']) - BUG_FIX_OFFSET;
  }
}
