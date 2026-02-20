import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../core/engine_provider.dart';
import '../core/mesh_engine.dart';
import '../core/permissions/ble_permissions.dart';
import '../transport/ble_transport.dart';

class BleState extends ChangeNotifier {
  List<ScanResult> devices = [];
  BluetoothDevice? connectedDevice;

  bool isScanning = false;
  String status = 'idle';

  final List<String> log = [];

  /// START SCAN
  Future<void> startScan() async {
    final ok = await BlePermissions.request();
    if (!ok) {
      status = 'permissions denied';
      notifyListeners();
      return;
    }

    isScanning = true;
    devices.clear();
    notifyListeners();

    FlutterBluePlus.onScanResults.listen((results) {
      devices = results;
      notifyListeners();
    });

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 10),
    );

    isScanning = false;
    notifyListeners();
  }

  /// CONNECT
  Future<void> connect(BluetoothDevice device) async {
    status = 'connecting';
    notifyListeners();

    try {
      final bleTransport = BleTransport();
      await bleTransport.connectDevice(device);

      EngineProvider.ble = MeshEngine(bleTransport);
      connectedDevice = device;
      status = 'connected';
      log.add('BLE connected');

      EngineProvider.ble!.rx.listen(_onData);
    } catch (e) {
      status = 'error: $e';
    }

    notifyListeners();
  }

  /// DISCONNECT
  Future<void> disconnect() async {
    await EngineProvider.ble?.disconnect();
    connectedDevice = null;
    status = 'disconnected';
    EngineProvider.ble = null;
    notifyListeners();
  }

  /// SEND HELLO (UI EXPECTS THIS)
  Future<void> sendHello() async {
    if (EngineProvider.ble == null) return;
    await EngineProvider.ble!.send(
      Uint8List.fromList([0x48, 0x65, 0x6c, 0x6c, 0x6f]),
    );
    log.add('TX: Hello');
    notifyListeners();
  }

  void _onData(Uint8List data) {
    final hex = data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    log.add('RX: $hex');
    notifyListeners();
  }
}
