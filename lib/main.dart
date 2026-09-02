import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
import 'core/localization/app_language_controller.dart';
import 'features/auth/widgets/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  await AppLanguageController.instance.initialize();

  runApp(const SwadhyayApp());
}

class SwadhyayApp extends StatelessWidget {
  const SwadhyayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = AppLanguageController.instance;

    return ListenableBuilder(
      listenable: languageController,
      builder: (context, child) {
        return MaterialApp(
          title: 'Swadhyay',
          debugShowCheckedModeBanner: false,
          locale: languageController.locale,
          supportedLocales: const [
            Locale('bn'),
            Locale('hi'),
            Locale('en'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepOrange,
            ),
            useMaterial3: true,
          ),
          home: AuthGate(),
        );
      },
    );
  }
}
