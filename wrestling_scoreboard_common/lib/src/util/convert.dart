import 'dart:typed_data';

Uint8List int32To5BitChunksBigEndian(int value) {
  const int bitsPerChunk = 5;
  const int chunkMask = (1 << bitsPerChunk) - 1; // 0x1F
  final int numChunks = (32 / bitsPerChunk).ceil(); // 7
  final chunks = Uint8List(numChunks);

  // Extract MSB‑first into chunks[0]…chunks[6]
  for (int i = 0; i < numChunks; i++) {
    final shift = (numChunks - 1 - i) * bitsPerChunk;
    chunks[i] = (value >> shift) & chunkMask;
  }

  // Find the first non-zero chunk
  final firstNonZero = chunks.indexWhere((b) => b != 0);
  if (firstNonZero < 0) {
    // value was zero → no chunks
    return Uint8List(0);
  }

  // Return from that index through the end
  return Uint8List.sublistView(chunks, firstNonZero);
}

const rfc4648Base64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
final rfc4648Base64Runes = rfc4648Base64.runes.toList();

String encodeBase32(int value) => int32To5BitChunksBigEndian(value).map((e) => rfc4648Base64[e]).join();

int decodeBase32(String value) {
  int res = 0;
  final indexedRunes = value.toUpperCase().runes.indexed;
  for (final (index, rune) in indexedRunes) {
    final runeIndex = rfc4648Base64Runes.indexOf(rune);
    if (runeIndex == -1) {
      throw FormatException('Cannot parse character ${String.fromCharCode(rune)}');
    }
    res += runeIndex << ((indexedRunes.length - 1 - index) * 5);
  }
  return res;
}
