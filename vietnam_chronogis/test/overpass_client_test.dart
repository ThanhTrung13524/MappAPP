import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_chronogis/data/api/overpass_api_client.dart';

void main() {
  test('OverpassApiClient can be created', () {
    final client = OverpassApiClient();
    expect(client, isNotNull);
  });
}
