import 'package:flutter/material.dart';

abstract class BaseModel with ChangeNotifier {
  // ! burası adam signin'e basınca sistem gecikmesi olacağı için
  // ! bir loading ekran gösterme yerinde işe yarayacak
  bool _busy = false;

  bool get busy => _busy;

  set busy(bool state) {
    _busy = state;

    notifyListeners();
  }
}
