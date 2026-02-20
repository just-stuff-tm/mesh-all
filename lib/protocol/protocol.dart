import 'dart:typed_data';

enum ProtocolType {
  meshcore,
  meshtastic,
  rnode,
  espnow,
  unknown,
  meshCoreProtocol,
}

abstract class MeshProtocol {
  ProtocolType get type;

  bool matches(Uint8List data);

  dynamic decode(Uint8List data);

  Uint8List encode(dynamic message);

  void onBytes(Uint8List data) {}
}
