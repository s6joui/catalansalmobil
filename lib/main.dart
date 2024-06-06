import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:catalansalmon_flutter/features/intro/presentation/intro_page.dart';
import 'package:catalansalmon_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      lazy: false,
      child: MaterialApp(
          title: 'Flutter Demo',
          darkTheme: ThemeData(
            useMaterial3: true,
            textTheme: textTheme,
            colorScheme: const ColorScheme(
                brightness: Brightness.dark,
                primary: Colors.white,
                onPrimary: Colors.black,
                secondary: Color(0x88FFFFFF),
                onSecondary: Color(0xFF222222),
                tertiary: Color(0x44FFFFFF),
                error: Colors.red,
                onError: Colors.black,
                surface: Colors.black,
                onSurface: Colors.white,
                primaryContainer: Color(0xFF222222),
                onPrimaryContainer: Colors.white),
          ),
          theme: ThemeData(
            useMaterial3: true,
            textTheme: textTheme,
            colorScheme: const ColorScheme(
                brightness: Brightness.light,
                primary: Colors.black,
                onPrimary: Colors.white,
                secondary: Color(0x88000000),
                onSecondary: Colors.white,
                tertiary: Color(0x44000000),
                error: Colors.red,
                onError: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
                primaryContainer: Colors.white,
                onPrimaryContainer: Colors.black),
          ),
          home: const IntroPage(shouldAttemptLogin: true)),
    );
  }
}
