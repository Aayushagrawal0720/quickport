import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClass {
  final String _UID = 'uid';
  final String _FNAME = 'fname';
  final String _LNAME = 'lname';
  final String _PHONE = 'phone';

  setUid(String uid) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString(_UID, uid);
  }

  Future<String> getUid() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getString(_UID);
  }

  setFName(String fname) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString(_FNAME, fname);
  }

  getFName() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getString(_FNAME);
  }

  setLName(String lname) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString(_LNAME, lname);
  }

  getLName() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getString(_LNAME);
  }

  setPhone(String phone) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString(_PHONE, phone);
  }

  getPhone() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getString(_PHONE);
  }
}
