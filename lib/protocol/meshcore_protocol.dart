import 'dart:typed_data';
import 'protocol.dart';

class MeshCoreProtocol implements MeshProtocol {
  @override
  ProtocolType get type => ProtocolType.meshCoreProtocol;

  @override
  dynamic decode(Uint8List bytes) {
    throw UnimplementedError();
  }

  @override
  Uint8List encode(dynamic data) {
    return Uint8List(0);
  }

  @override
  bool matches(Uint8List bytes) {
    return false;
  }

  @override
  void onBytes(Uint8List bytes) {
    // Protocol parsing deferred
  }
}
