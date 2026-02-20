import 'package:flutter/material.dart';
import 'ui/connection_selector.dart';

class MeshUtilityApp extends StatelessWidget {
  const MeshUtilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mesh Utility',
      theme: ThemeData.dark(useMaterial3: true),
      home: const ConnectionSelectorScreen(),
    );
  }
}