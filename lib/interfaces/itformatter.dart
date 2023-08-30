abstract class ITimeFormatter {
  //
  // Get cooling time.
  //
  double get(bool rFlag);
  //
  // Get fraction of the given number.
  //
  int getFraction(String value);
  //
  // Get cooling time (minutes).
  //
  int getHours(bool rFlag);
  //
  // Get cooling time (minutes).
  //
  int getMinutes(bool rFlag, {bool mpmFlag = true});
  //
  // Round cooling time.
  //
  double round({bool mpmFlag = true});
}
