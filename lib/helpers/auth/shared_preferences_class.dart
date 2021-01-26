import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClass {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  final String _kNotificationsCount = "NotificationsCount";
  final String _kLoginPrefs = "loginChecker";
  final String _kTourGuidePrefs = "tourGuideChecker";
  final String _kLoginFileDigestPrefs = "loginFileDigest";
  final String _kTokenPrefs = "loginToken";
  final String _kUserTypePrefs = "userType";
  final String _kAudioCallPricePrefs = "audioCallPricePrefs";
  final String _kVideoCallPricePrefs = "videoCallPricePrefs";
  final String _kSortingOrderPrefs = "sortOrder";

  /// ------------------------------------------------------------
  /// Method that returns the user is logged-in or not
  /// ------------------------------------------------------------
  Future<bool> getLoginChecker() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLoginPrefs) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves the user is logged-in or not
  /// ----------------------------------------------------------
  Future<bool> setLoginChecker(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_kLoginPrefs, value);
  }

  /// ------------------------------------------------------------
  /// Method that returns the user has seen tour guide or not
  /// ------------------------------------------------------------
  Future<bool> getTourGuideChecker() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kTourGuidePrefs) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves the user has seen tour guide or not
  /// ----------------------------------------------------------
  Future<bool> setTourGuideChecker(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_kTourGuidePrefs, value);
  }

  /// ------------------------------------------------------------
  /// Method that returns user notifications count
  /// ------------------------------------------------------------
  Future<int> getNotificationsCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kNotificationsCount) ?? 0;
  }

  /// ----------------------------------------------------------
  /// Method that user notifications count
  /// ----------------------------------------------------------
  Future<bool> setNotificationsCount(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //print("::::: setNotificationsCount "+value.toString());
    return prefs.setInt(_kNotificationsCount, value);
  }

  /// ------------------------------------------------------------
  /// Method that returns the user login token
  /// ------------------------------------------------------------
  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTokenPrefs) ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user login token
  /// ----------------------------------------------------------
  Future<bool> setToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kTokenPrefs, value);
  }

  /// ------------------------------------------------------------
  /// Method that returns the user type
  /// ------------------------------------------------------------
  Future<String> getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserTypePrefs) ?? 'manager';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user type
  /// ----------------------------------------------------------
  Future<bool> setUserType(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kUserTypePrefs, value);
  }

  /// ------------------------------------------------------------
  /// Method that returns the vip audioCallPrice
  /// ------------------------------------------------------------
  Future<int> getAudioCallPrice() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kAudioCallPricePrefs) ?? 0;
  }

  /// ----------------------------------------------------------
  /// Method that saves the vip audioCallPrice
  /// ----------------------------------------------------------
  Future<bool> setAudioCallPrice(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_kAudioCallPricePrefs, value);
  }

  /// ------------------------------------------------------------
  /// Method that returns the vip videoCallPrice
  /// ------------------------------------------------------------
  Future<int> getSetVideoCallPrice() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kVideoCallPricePrefs) ?? 0;
  }

  /// ----------------------------------------------------------
  /// Method that saves the vip videoCallPrice
  /// ----------------------------------------------------------
  Future<bool> setVideoCallPrice(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_kVideoCallPricePrefs, value);
  }

  // ------------------------------------------------------------
  /// Method that returns the user decision to allow notifications
  /// ------------------------------------------------------------
  Future<String> getLoginFileDigest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kLoginFileDigestPrefs) ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user decision to allow notifications
  /// ----------------------------------------------------------
  Future<bool> setLoginFileDigest(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kLoginFileDigestPrefs, value);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user decision to allow notifications
  /// ----------------------------------------------------------
  Future<bool> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  /// ------------------------------------------------------------
  /// Method that returns the user decision on sorting order
  /// ------------------------------------------------------------
  Future<String> getSortingOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_kSortingOrderPrefs) ?? 'name';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user decision on sorting order
  /// ----------------------------------------------------------
  Future<bool> setSortingOrder(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_kSortingOrderPrefs, value);
  }
}