import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/core/services/supabase_service.dart';
import 'package:todo_app/features/auth/providers/auth_provider.dart';
import 'package:todo_app/features/auth/screens/login_screen.dart';
import 'package:todo_app/features/home/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: '.env');
  
  // Initialize Supabase using the service
  await SupabaseService.initialize();
  
  runApp(
    // Adding ProviderScope to enable Riverpod in the app
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state changes
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: authState.when(
        data: (state) {
          switch (state) {
            case AuthState.authenticated:
              return const HomeScreen();
            case AuthState.unauthenticated:
            case AuthState.initial:
              return const LoginScreen();
            case AuthState.loading:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case AuthState.error:
              return const Scaffold(
                body: Center(
                  child: Text('An error occurred'),
                ),
              );
          }
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Scaffold(
          body: Center(
            child: Text('Error: ${error.toString()}'),
          ),
        ),
      ),
    );
  }
}