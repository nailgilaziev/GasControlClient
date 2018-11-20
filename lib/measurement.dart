
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
    position = int.parse(j['field5']);

    // FIXME TMP FIX THINGSPEAK DATA BUG https://github.com/nailgilaziev/GasControl/issues/6
    if (position > 500) {
      position -= 500;
    }
    if (position > 50) {
      position -= 50;
    }
  }
}
