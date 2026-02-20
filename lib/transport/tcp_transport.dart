import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'transport.dart';

class TcpTransport implements Transport {
  final String host;
  final int port;

  Socket? _socket;
  final _rx = StreamController<Uint8List>.broadcast();

  TcpTransport(this.host, this.port);

  @override
  String get id => 'tcp:$host:$port';

  @override
  bool get isConnected => _socket != null;

  @override
  Stream<Uint8List> get rx => _rx.stream;

  @override
  Future<void> connect() async {
    _socket = await Socket.connect(host, port);
    _socket!.listen(
      (data) => _rx.add(Uint8List.fromList(data)),
      onDone: disconnect,
      onError: (_) => disconnect(),
    );
  }

  @override
  Future<void> send(Uint8List data) async {
    _socket?.add(data);
  }

  @override
  Future<void> disconnect() async {
    await _socket?.close();
    _socket = null;
  }
}
