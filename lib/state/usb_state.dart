import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:usb_serial/usb_serial.dart';

import '../core/engine_provider.dart';
import '../core/mesh_engine.dart';
import '../transport/usb_transport.dart';

class UsbState extends ChangeNotifier {
  bool isConnected = false;
  String status = 'idle';

  List<UsbDevice> devices = [];
  final List<String> log = [];

  Future<void> refreshDevices() async {
    devices = await UsbSerial.listDevices();
    log.add('Found ${devices.length} USB devices');
    notifyListeners();
  }

  Future<void> connect(UsbDevice device) async {
    status = 'connecting';
    notifyListeners();

    try {
      final usbTransport = UsbTransport(device);
      await usbTransport.connect();

      EngineProvider.usb = MeshEngine(usbTransport);
      status = 'connected';
      isConnected = true;
      log.add('USB connected');

      EngineProvider.usb!.rx.listen((Uint8List data) {
        log.add('RX ${data.length} bytes');
        notifyListeners();
      });
    } catch (e) {
      status = 'error: $e';
    }

    notifyListeners();
  }

  Future<void> send(Uint8List data) async {
    if (EngineProvider.usb == null) return;
    await EngineProvider.usb!.send(data);
    log.add('TX ${data.length} bytes');
    notifyListeners();
  }

  Future<void> sendHello() async {
    await send(Uint8List.fromList([0x48, 0x49]));
  }

  Future<void> disconnect() async {
    await EngineProvider.usb?.disconnect();
    EngineProvider.usb = null;
    isConnected = false;
    status = 'disconnected';
    notifyListeners();
  }
}
