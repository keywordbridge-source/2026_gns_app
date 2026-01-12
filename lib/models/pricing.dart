class Pricing {
  static const int oneHourPrice = 10000;
  static const int twoHourPrice = 20000;
  static const int fourHourPrice = 30000;
  static const int additionalFeePerMinute = 300;

  static int getPrice(int hours) {
    switch (hours) {
      case 1:
        return oneHourPrice;
      case 2:
        return twoHourPrice;
      case 4:
        return fourHourPrice;
      default:
        return oneHourPrice;
    }
  }

  static int calculateAdditionalFee(DateTime startTime, DateTime endTime) {
    final now = DateTime.now();
    if (now.isAfter(endTime)) {
      final overtimeMinutes = now.difference(endTime).inMinutes;
      return overtimeMinutes * additionalFeePerMinute;
    }
    return 0;
  }
}
