import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/game_repository.dart';
import 'data/services/storage_service.dart';
import 'ui/screens/main_navigation_screen.dart';
import 'ui/view_models/game_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dark system navigation and status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final storageService = await StorageService.init();
  final gameRepository = GameRepository(storageService: storageService);
  final gameViewModel = GameViewModel(repository: gameRepository);

  await gameViewModel.init();

  runApp(HabitQuestApp(viewModel: gameViewModel));
}

class HabitQuestApp extends StatelessWidget {
  final GameViewModel viewModel;

  const HabitQuestApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return MaterialApp(
          title: 'HabitQuest',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: MainNavigationScreen(viewModel: viewModel),
        );
      },
    );
  }
}
