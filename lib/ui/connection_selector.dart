import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/connection_state.dart';
import 'ble_screen.dart';
import 'tcp_screen.dart';
import 'usb_screen.dart';

class ConnectionSelectorScreen extends StatelessWidget {
  const ConnectionSelectorScreen({super.key});

  String _labelFor(ConnectionType type) {
    switch (type) {
      case ConnectionType.ble:
        return 'Bluetooth LE';
      case ConnectionType.usb:
        return 'USB Serial';
      case ConnectionType.tcp:
        return 'TCP / IP';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ConnectionStateModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Select Connection')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _button(context, state, ConnectionType.ble),
            _button(context, state, ConnectionType.usb),
            _button(context, state, ConnectionType.tcp),
            if (state.selected != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text('Selected: ${_labelFor(state.selected!)}'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _button(
    BuildContext context,
    ConnectionStateModel state,
    ConnectionType type,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ElevatedButton(
        onPressed: () {
          state.select(type);

          switch (type) {
            case ConnectionType.ble:
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const BleScreen()));
              break;
            case ConnectionType.tcp:
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TcpScreen()));
              break;
            case ConnectionType.usb:
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const UsbScreen()));
              break;
          }
        },
        child: Text(_labelFor(type)),
      ),
    );
  }
}
