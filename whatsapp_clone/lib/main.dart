import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/core/locator.dart';
import 'package:whatsapp_clone/core/services/navigator_service.dart';
import 'package:whatsapp_clone/screens/sign_in_page.dart';
import 'package:whatsapp_clone/viewmodels/sign_in_model.dart';
import 'package:whatsapp_clone/whatsapp_main.dart';
import 'firebase_options.dart';

void main() async {
  // ! proje başlayınca bu methodu çağırıp ihtiyacımız olan servis classlarını
  // ! initialize edecek uyhulama çalışınca get_it paketi üzerinden çağıracaz
  setUpLocators();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xff075E54)));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData();
    return FutureProvider(
      // ! FutureProvider olayında sıkıntı var gibi koda bakan biri issue atabilir mi
      // ! amacım auth_service ve sign_in_model dosyalarındaki
      // ! currentUser getter'ını kullanarak kayıtlı biri varsa
      // ! WhatsappMain'e yoksa SignInPage' gitmesini sağlamak
      // ! ama firebase'deki profile collection'u silince gene WhatsappMain'e atıyor
      initialData: Future.value(getIt<SignInModel>().currentUser),
      create: (context) => Future.value(getIt<SignInModel>().currentUser),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // ! BURASI ÖNEMLİ GLOBAL KEY İÇİN
        navigatorKey: getIt<NavigatorService>().navigatorKey,
        title: 'Whatsapp Clone',
        theme: theme.copyWith(
            primaryColor: const Color(0xff075E54),
            appBarTheme: const AppBarTheme(color: Color(0xff075E54)),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color(0xff25D366))),
        home: Consumer(
          builder: (context, value, child) =>
              value == null ? const SignInPage() : const WhatsappMain(),
        ),
      ),
    );
  }
}
