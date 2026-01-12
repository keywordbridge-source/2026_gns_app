class AppConfig {
  // Iamport Channel Keys
  static const String inisisChannelKey = 'channel-key-cbc91735-ccb5-4045-8ac1-4ef3f3731e8d';
  static const String kakaoPayChannelKey = 'channel-key-bcd6a1a1-d68f-407c-a9a1-5085029cc69b';
  
  // Time Settings
  static const int startHour = 9;
  static const int endHour = 17;
  static const List<int> availableDurations = [1, 2, 4];
  static const int seatsPerHour = 10;
  
  // Validation
  static const int maxCustomerNameLength = 5;
  static const int customerPasswordLength = 4;
  
  // Demo Site
  static const String demoSiteUrl = 'https://5060-i1ytwr3anjc98ir9e40du-b32ec7bb.sandbox.novita.ai';
}
