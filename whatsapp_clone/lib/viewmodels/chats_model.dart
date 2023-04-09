import 'package:get_it/get_it.dart';
import 'package:whatsapp_clone/core/services/chat_service.dart';
import 'package:whatsapp_clone/models/conversations.dart';
import 'package:whatsapp_clone/viewmodels/base_model.dart';

class ChatsModel extends BaseModel {
  // ! get_it paketi ile firestoredb classını çekip _db isimli fielda verdik
  final ChatService _db = GetIt.instance<ChatService>();

  Stream<List<Conversations>> conversations(String userId) {
    return _db.getConversations(userId);
  }
}
