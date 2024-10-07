import 'dart:math';

class EntropyGenerator {
  static String generateEntropy() {
    final random = Random.secure();
    return List.generate(6, (_) => random.nextInt(256).toRadixString(16)).join();
  }
}
