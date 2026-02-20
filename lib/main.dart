import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'state/connection_state.dart';
import 'state/ble_state.dart';
import 'state/tcp_state.dart';
import 'state/usb_state.dart';

void main() {
  // Initialize engine before UI
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectionStateModel()),
        ChangeNotifierProvider(create: (_) => BleState()),
        ChangeNotifierProvider(create: (_) => TcpState()),
        ChangeNotifierProvider(create: (_) => UsbState()),
      ],
      child: const MeshUtilityApp(),
    ),
  );
}
