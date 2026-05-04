import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ✅ IMPORT the router provider file here
// Replace 'job_market' with your actual package name if it differs
import 'package:job_market/core/router/app_router.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🛡️ WATCH the generated routerProvider
    // Riverpod takes your 'router' function and generates 'routerProvider'
    final goRouter = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'GemCost Jobs',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF10C971),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF10C971),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,

      // 🔄 Use the configuration provided by the Riverpod provider
      routerConfig: goRouter,
    );
  }
}