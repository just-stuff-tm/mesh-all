import 'package:flutter/material.dart';

enum ConnectionType { ble, usb, tcp }

class ConnectionStateModel extends ChangeNotifier {
  ConnectionType? selected;

  bool connected = false;
  bool busy = false;

  void select(ConnectionType type) {
    selected = type;
    connected = false;
    notifyListeners();
  }

  void setBusy(bool value) {
    busy = value;
    notifyListeners();
  }

  void setConnected(bool value) {
    connected = value;
    notifyListeners();
  }

  void reset() {
    selected = null;
    connected = false;
    busy = false;
    notifyListeners();
  }
}
