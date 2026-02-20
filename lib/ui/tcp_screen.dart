import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/tcp_state.dart';

class TcpScreen extends StatelessWidget {
  const TcpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TcpView();
  }
}

class _TcpView extends StatefulWidget {
  const _TcpView();

  @override
  State<_TcpView> createState() => _TcpViewState();
}

class _TcpViewState extends State<_TcpView> {
  final hostCtrl = TextEditingController(text: '192.168.1.1');
  final portCtrl = TextEditingController(text: '5000');

  @override
  Widget build(BuildContext context) {
    final tcp = context.watch<TcpState>();

    return Scaffold(
      appBar: AppBar(title: const Text('TCP / IP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Status: ${tcp.status}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            TextField(controller: hostCtrl, decoration: const InputDecoration(labelText: 'Host')),
            TextField(controller: portCtrl, decoration: const InputDecoration(labelText: 'Port')),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: tcp.isBusy
                  ? null
                  : () => tcp.connect(hostCtrl.text.trim(), int.parse(portCtrl.text)),
              child: const Text('Connect'),
            ),

            const Divider(),

            Expanded(
              child: ListView.builder(
                itemCount: tcp.log.length,
                itemBuilder: (_, i) =>
                    Text(tcp.log[i], style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
