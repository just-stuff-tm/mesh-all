import 'dart:typed_data';

import '../transport/transport.dart';

class MeshEngine {
  final Transport transport;

  MeshEngine(this.transport);

  Stream<Uint8List> get rx => transport.rx;

  Future<void> connect() => transport.connect();

  Future<void> disconnect() => transport.disconnect();

  Future<void> send(Uint8List data) => transport.send(data);
}
