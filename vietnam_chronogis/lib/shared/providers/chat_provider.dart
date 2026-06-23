import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/api/groq_service.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/administrative_unit_repository.dart';
import '../models/chat_message.dart';
import '../models/chat_context.dart';
// FIX: thêm import này để extension .label của VietnamEra vào scope
import '../models/timeline_era.dart';
import 'timeline_provider.dart';
import 'map_provider.dart';

final chatMessagesProvider = StreamProvider<List<ChatMessage>>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.watchMessages();
});

final currentChatContextProvider = FutureProvider<ChatContext>((ref) async {
  final year = ref.watch(selectedYearProvider);
  final era = ref.watch(currentEraProvider);
  final provinceCount = ref.watch(currentProvinceCountProvider);
  final selectedMa = ref.watch(selectedProvinceProvider);

  String? embedText;
  if (selectedMa != null) {
    final repo = ref.watch(administrativeUnitRepositoryProvider);
    final unit = await repo.getUnitByMa(selectedMa);
    embedText = unit?.embedText;
  }

  return ChatContext(
    currentYear: year,
    selectedProvinceMa: selectedMa,
    selectedProvinceEmbedText: embedText,
    provinceCount: provinceCount,
    // FIX: era.label sekarang in scope vì đã import timeline_era.dart
    currentEra: era.label,
  );
});

final suggestedQuestionsProvider = FutureProvider<List<String>>((ref) async {
  final context = await ref.watch(currentChatContextProvider.future);
  final groq = ref.watch(groqServiceProvider);
  return groq.generateSuggestedQuestions(context);
});

// FIX: StateNotifierProvider → NotifierProvider
final chatNotifierProvider = NotifierProvider<ChatNotifier, List<ChatMessage>>(
  ChatNotifier.new,
);

// FIX: StateNotifier<T> → Notifier<T>
// - Không cần inject GroqService, ChatRepository, Ref qua constructor nữa
// - Dùng ref trực tiếp bên trong Notifier
class ChatNotifier extends Notifier<List<ChatMessage>> {
  late GroqService _groqService;
  late ChatRepository _repository;
  final _uuid = const Uuid();

  @override
  List<ChatMessage> build() {
    // FIX: ref có sẵn, không cần super(initialState) constructor
    _groqService = ref.read(groqServiceProvider);
    _repository = ref.read(chatRepositoryProvider);
    return [];
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      role: MessageRole.user,
      content: text,
      timestamp: DateTime.now(),
    );

    await _repository.saveMessage(userMessage);

    final aiMessageId = _uuid.v4();
    final aiMessage = ChatMessage(
      id: aiMessageId,
      role: MessageRole.assistant,
      content: '',
      timestamp: DateTime.now(),
      isStreaming: true,
    );

    // FIX: state= trực tiếp trong Notifier (thay vì undefined 'state')
    state = [...state, aiMessage];

    try {
      // FIX: dùng ref.read thay vì _ref.read
      final chatContext = await ref.read(currentChatContextProvider.future);
      final stream = _groqService.sendMessage(text, context: chatContext);

      String accumulatedContent = '';

      await for (final chunk in stream) {
        accumulatedContent += chunk;
        state = [
          ...state.where((m) => m.id != aiMessageId),
          aiMessage.copyWith(content: accumulatedContent),
        ];
      }

      final finalMessage = aiMessage.copyWith(
        content: accumulatedContent,
        isStreaming: false,
      );

      state = state.where((m) => m.id != aiMessageId).toList();
      await _repository.saveMessage(finalMessage);
    } catch (e) {
      state = state.where((m) => m.id != aiMessageId).toList();
      await _repository.saveMessage(
        ChatMessage(
          id: _uuid.v4(),
          role: MessageRole.assistant,
          content: 'Lỗi: Không thể kết nối với AI. ($e)',
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  Future<void> clearHistory() async {
    await _repository.clearHistory();
    state = [];
  }
}
