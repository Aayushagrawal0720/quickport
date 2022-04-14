import 'package:flutter/cupertino.dart';

class CodeResendTimerService with ChangeNotifier {
  int time = 60;

  initTime() async {
    while (time >= 0) {
      await Future.delayed(const Duration(seconds: 1));
      time--;
      notifyListeners();
    }
  }

  int getTime() => time;
}
