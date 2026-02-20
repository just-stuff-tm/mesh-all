import 'dart:async';
import 'dart:typed_data';

import 'package:usb_serial/usb_serial.dart';
import 'package:usb_serial/transaction.dart';

import 'transport.dart';

class UsbTransport implements Transport {
  final UsbDevice device;

  UsbPort? _port;
  Transaction<Uint8List>? _transaction;
  StreamSubscription? _sub;

  final _rx = StreamController<Uint8List>.broadcast();

  UsbTransport(this.device);

  @override
  String get id => 'usb:${device.deviceId}';

  @override
  bool get isConnected => _port != null;

  @override
  Stream<Uint8List> get rx => _rx.stream;

  @override
  Future<void> connect() async {
    _port = await device.create();
    await _port!.open();

    await _port!.setPortParameters(
      115200,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    _transaction = Transaction.terminated(
      _port!.inputStream!,
      Uint8List.fromList([0x0A]),
    );

    _sub = _transaction!.stream.listen(_rx.add);
  }

  @override
  Future<void> send(Uint8List data) async {
    await _port?.write(data);
  }

  @override
  Future<void> disconnect() async {
    await _sub?.cancel();
    await _port?.close();
    _port = null;
  }
}
