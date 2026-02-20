import 'dart:typed_data';

abstract class Transport {
  String get id;

  bool get isConnected;

  Stream<Uint8List> get rx;

  Future<void> connect();

  Future<void> disconnect();

  Future<void> send(Uint8List data);
}
  