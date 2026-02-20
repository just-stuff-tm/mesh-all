import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/ble_state.dart';

class BleScreen extends StatelessWidget {
  const BleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ble = context.watch<BleState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth LE'),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: Column(
        children: [
          _statusCard(ble),
          const Divider(),

          if (ble.connectedDevice == null)
            _scanControls(ble)
          else
            _connectedControls(ble),

          const Divider(),
          Expanded(child: _logView(ble)),
        ],
      ),
    );
  }

  /* ---------------- Status ---------------- */

  Widget _statusCard(BleState ble) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Status: ${ble.status}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /* ---------------- Scan UI ---------------- */

  Widget _scanControls(BleState ble) {
    return Expanded(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: ble.isScanning ? null : ble.startScan,
            child: const Text('Scan'),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              itemCount: ble.devices.length,
              itemBuilder: (_, i) {
                final r = ble.devices[i];
                final name =
                    r.device.platformName.isNotEmpty
                        ? r.device.platformName
                        : 'Unknown';

                return ListTile(
                  leading: const Icon(Icons.bluetooth),
                  title: Text(name),
                  subtitle: Text(r.device.remoteId.str),
                  trailing: Text('${r.rssi} dBm'),
                  onTap: () => ble.connect(r.device),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /* ---------------- Connected UI ---------------- */

  Widget _connectedControls(BleState ble) {
    final d = ble.connectedDevice!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.bluetooth_connected),
              title: Text(
                d.platformName.isNotEmpty
                    ? d.platformName
                    : 'Unknown device',
              ),
              subtitle: Text(d.remoteId.str),
              trailing: ElevatedButton(
                onPressed: ble.disconnect,
                child: const Text('Disconnect'),
              ),
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: ble.sendHello,
            child: const Text('Send "Hello"'),
          ),
        ],
      ),
    );
  }

  /* ---------------- Log ---------------- */

  Widget _logView(BleState ble) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: ble.log.length,
      itemBuilder: (_, i) => Text(
        ble.log[i],
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
        ),
      ),
    );
  }
}
