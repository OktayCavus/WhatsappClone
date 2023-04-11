import 'package:flutter/material.dart';
import 'package:whatsapp_clone/core/locator.dart';

import '../core/services/navigator_service.dart';

abstract class BaseModel with ChangeNotifier {
  final NavigatorService navigatorService = getIt<NavigatorService>();

  // ! burası adam signin'e basınca sistem gecikmesi olacağı için
  // ! bir loading ekran gösterme yerinde işe yarayacak
  bool _busy = false;

  bool get busy => _busy;

  set busy(bool state) {
    _busy = state;

    notifyListeners();
  }
}
