import 'dart:typed_data';
import 'protocol.dart';

class RNodeProtocol implements MeshProtocol {
  @override
  dynamic decode(Uint8List data) {
    throw UnimplementedError();
  }

  @override
  Uint8List encode(dynamic message) {
    throw UnimplementedError();
  }

  @override
  bool matches(Uint8List data) {
    throw UnimplementedError();
  }

  @override
  void onBytes(Uint8List data) {
    // Protocol parsing deferred
  }

  @override
  ProtocolType get type => throw UnimplementedError();
}
