import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_chronogis/data/api/groq_service.dart';

void main() {
  test('Groq service is unavailable instead of throwing without API key', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(groqApiKeyConfiguredProvider), isFalse);
    expect(container.read(groqServiceProvider), isNull);
  });
}
