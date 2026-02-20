import 'dart:typed_data';
import 'protocol.dart';

class MeshtasticProtocol implements MeshProtocol {
  @override
  Uint8List encode(dynamic message) {
    throw UnimplementedError();
  }

  @override
  dynamic decode(Uint8List data) {
    throw UnimplementedError();
  }

  @override
  bool matches(Uint8List data) {
    throw UnimplementedError();
  }

  @override
  void onBytes(Uint8List data) {
    throw UnimplementedError();
  }

  @override
  ProtocolType get type => ProtocolType.meshtastic;
}
