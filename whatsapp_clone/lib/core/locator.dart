import 'package:get_it/get_it.dart';
import 'package:whatsapp_clone/core/services/auth_service.dart';
import 'package:whatsapp_clone/core/services/chat_service.dart';
import 'package:whatsapp_clone/core/services/navigator_service.dart';
import 'package:whatsapp_clone/viewmodels/chats_model.dart';
import 'package:whatsapp_clone/viewmodels/main_model.dart';
import 'package:whatsapp_clone/viewmodels/sign_in_model.dart';

GetIt getIt = GetIt.instance;

setUpLocators() {
  // ! bu şekilde firestoreDB classnı bir kere oluşturup
  // ! ne zaman çağırırsak o classı bize dönen yapıyı elde ettik
  // ! singleton ile bunu yaptık
  getIt.registerLazySingleton(() => ChatService());
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => NavigatorService());

  getIt.registerFactory(() => ChatsModel());
  getIt.registerFactory(() => SignInModel());
  getIt.registerFactory(() => MainModel());
}
