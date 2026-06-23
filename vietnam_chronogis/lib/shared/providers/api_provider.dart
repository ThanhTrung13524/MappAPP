import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api/huggingface_api_client.dart';

final huggingFaceApiClientProvider = Provider<HuggingFaceApiClient>((ref) {
  return HuggingFaceApiClient();
});
