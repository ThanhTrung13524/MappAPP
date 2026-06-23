import 'package:vietnam_chronogis/data/api/overpass_api_client.dart';

Future<void> main() async {
  final client = OverpassApiClient();
  final places = await client.fetchAllVietnamLandmarks();
  print('places=${places.length}');
}
