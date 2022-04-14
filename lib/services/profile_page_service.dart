import 'package:flutter/cupertino.dart';
import 'package:localport_alter_delivery/SharedPreferences/sharedpreferences_class.dart';

class ProfilePageService with ChangeNotifier {
  String _name;
  String _mobile;

  fetchProfileInfo() async {
    _name = await SharedPreferencesClass().getFName() +
        " " +
        await SharedPreferencesClass().getLName();
    _mobile = await SharedPreferencesClass().getPhone();
    notifyListeners();
  }

  getName() => _name;

  getPhone() => _mobile;
}
