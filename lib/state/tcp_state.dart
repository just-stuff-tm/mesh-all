import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../core/engine_provider.dart';
import '../core/mesh_engine.dart';
import '../transport/tcp_transport.dart';

class TcpState extends ChangeNotifier {
  String status = 'idle';
  bool isBusy = false;

  final List<String> log = [];

  Future<void> connect(String host, int port) async {
    if (isBusy) return;

    isBusy = true;
    status = 'connecting';
    notifyListeners();

    try {
      final tcpTransport = TcpTransport(host, port);
      await tcpTransport.connect();

      EngineProvider.tcp = MeshEngine(tcpTransport);
      status = 'connected';
      log.add('TCP connected to $host:$port');

      EngineProvider.tcp!.rx.listen((Uint8List data) {
        log.add('RX ${data.length} bytes');
        notifyListeners();
      });
    } catch (e) {
      status = 'error: $e';
      log.add(status);
    }

    isBusy = false;
    notifyListeners();
  }

  Future<void> send(Uint8List data) async {
    if (EngineProvider.tcp == null) return;
    await EngineProvider.tcp!.send(data);
    log.add('TX ${data.length} bytes');
    notifyListeners();
  }

  Future<void> sendHello() async {
    await send(Uint8List.fromList([0x48, 0x69])); // "Hi"
  }

  Future<void> disconnect() async {
    await EngineProvider.tcp?.disconnect();
    EngineProvider.tcp = null;
    status = 'disconnected';
    notifyListeners();
  }
}
