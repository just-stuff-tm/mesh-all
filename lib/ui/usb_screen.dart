import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/usb_state.dart';

class UsbScreen extends StatelessWidget {
  const UsbScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usb = context.watch<UsbState>();

    return Scaffold(
      appBar: AppBar(title: const Text('USB Serial')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Status: ${usb.status}', style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: usb.refreshDevices, child: const Text('Scan USB')),
                ElevatedButton(
                  onPressed: usb.isConnected ? usb.sendHello : null,
                  child: const Text('Send'),
                ),
              ],
            ),

            const Divider(),

            Expanded(
              child: ListView.builder(
                itemCount: usb.devices.length,
                itemBuilder: (_, i) {
                  final d = usb.devices[i];
                  return ListTile(
                    leading: const Icon(Icons.usb),
                    title: Text(d.productName ?? 'USB Device'),
                    subtitle: Text('VID:${d.vid} PID:${d.pid}'),
                    onTap: () => usb.connect(d),
                  );
                },
              ),
            ),

            const Divider(),

            Expanded(
              child: ListView.builder(
                itemCount: usb.log.length,
                itemBuilder: (_, i) =>
                    Text(usb.log[i], style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
