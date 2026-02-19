import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/quran_data/repository/quran_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AiHafizApp());
}

class AiHafizApp extends StatelessWidget {
  const AiHafizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => QuranRepository(),
      child: MaterialApp(
        title: 'AI Hafiz',
        theme: AppTheme.darkTheme,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
