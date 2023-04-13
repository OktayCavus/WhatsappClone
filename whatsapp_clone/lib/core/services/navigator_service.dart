import 'package:flutter/material.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  void pop() {
    _navigatorKey.currentState!.pop();
  }

  Future navigateTo(Widget route) {
    return _navigatorKey.currentState!
        .push(MaterialPageRoute(builder: (context) => route));
  }

  Future navigateAndReplace(Widget route) {
    return _navigatorKey.currentState!
        .pushReplacement(MaterialPageRoute(builder: (context) => route));
  }
}
