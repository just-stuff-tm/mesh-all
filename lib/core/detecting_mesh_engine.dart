import 'dart:async';
import 'dart:typed_data';

import '../transport/transport.dart';
import '../protocol/protocol.dart';
import '../protocol/meshcore_protocol.dart';
import '../protocol/meshtastic_protocol.dart';
import '../protocol/rnode_protocol.dart';
import '../protocol/espnow_protocol.dart';
import '../detect/protocol_detector.dart';

class DetectingMeshEngine {
  final Transport transport;

  MeshProtocol? _protocol;
  StreamSubscription<Uint8List>? _sub;

  DetectingMeshEngine(this.transport) {
    _sub = transport.rx.listen(_onBytes);
  }

  MeshProtocol get protocol {
    if (_protocol == null) {
      throw StateError('Protocol not detected yet');
    }
    return _protocol!;
  }

  void _onBytes(Uint8List data) {
    if (_protocol == null) {
      final detected = ProtocolDetector.detect(data);

      switch (detected) {
        case DetectedProtocol.meshcore:
          _protocol = MeshCoreProtocol();
          break;
        case DetectedProtocol.meshtastic:
          _protocol = MeshtasticProtocol();
          break;
        case DetectedProtocol.rnode:
          _protocol = RNodeProtocol();
          break;
        case DetectedProtocol.espnow:
          _protocol = EspNowProtocol();
          break;
        case DetectedProtocol.unknown:
          return; // wait for more bytes
      }

      // Lock protocol + rewire RX
      _sub?.cancel();
      transport.rx.listen((data) => _protocol!.onBytes(data));

      // Feed first packet manually
      _protocol!.onBytes(data);
    } else {
      _protocol!.onBytes(data);
    }
  }

  Future<void> send(dynamic message) {
    if (_protocol == null) {
      throw StateError('Protocol not detected yet');
    }
    final bytes = _protocol!.encode(message);
    return transport.send(bytes);
  }
}
