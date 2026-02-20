import 'dart:typed_data';
import '../protocol/protocol.dart';

abstract class MeshDetector {
  MeshProtocol? detect(Uint8List data);
}
