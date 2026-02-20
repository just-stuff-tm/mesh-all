class ProtocolSignature {
  final String name;
  final bool Function(List<int> bytes) match;

  const ProtocolSignature(this.name, this.match);
}

final meshcoreSignature = ProtocolSignature(
  'meshcore',
  (b) => b.isNotEmpty && b[0] == 0x7E, // frame start
);

final meshtasticSignature = ProtocolSignature(
  'meshtastic',
  (b) => b.length > 4 && b[0] == 0x94 && b[1] == 0xC3,
);

final rnodeSignature = ProtocolSignature(
  'rnode',
  (b) => b.length > 2 && b[0] == 0xAA && b[1] == 0x55,
);

final espNowSignature = ProtocolSignature(
  'espnow',
  (b) => b.length > 6 && b[0] == 0xFE,
);

final knownSignatures = [
  meshcoreSignature,
  meshtasticSignature,
  rnodeSignature,
  espNowSignature,
];
