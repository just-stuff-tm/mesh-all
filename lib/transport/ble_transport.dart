import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'transport.dart';

class BleTransport implements Transport {
  BluetoothDevice? _device;
  BluetoothCharacteristic? _tx;

  final _rx = StreamController<Uint8List>.broadcast();

  @override
  String get id => _device?.remoteId.str ?? 'ble:unknown';

  @override
  bool get isConnected => _device != null;

  @override
  Stream<Uint8List> get rx => _rx.stream;

  @override
  Future<void> connect() async {
    // This method expects the device to be set externally
    // or can be overridden by subclasses
    throw UnimplementedError('Use connectDevice() instead');
  }

  Future<void> connectDevice(BluetoothDevice device) async {
    await device.connect();

    final services = await device.discoverServices();
    BluetoothCharacteristic? txChar;
    BluetoothCharacteristic? rxChar;

    for (var service in services) {
      for (var char in service.characteristics) {
        if (char.uuid.toString().toLowerCase().contains('tx')) {
          txChar = char;
        } else if (char.uuid.toString().toLowerCase().contains('rx')) {
          rxChar = char;
        }
      }
    }

    if (txChar != null && rxChar != null) {
      _device = device;
      _tx = txChar;

      await rxChar.setNotifyValue(true);
      rxChar.lastValueStream.listen((data) => _rx.add(Uint8List.fromList(data)));
    } else {
      throw Exception('TX or RX characteristic not found');
    }
  }

  @override
  Future<void> send(Uint8List data) async {
    await _tx?.write(data, withoutResponse: false);
  }

  @override
  Future<void> disconnect() async {
    await _device?.disconnect();
    _device = null;
  }
}
