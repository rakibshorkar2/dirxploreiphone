import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: DirXploreApp(),
    ),
  );
}

class DirXploreApp extends ConsumerWidget {
  const DirXploreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoApp.router(
      title: 'DirXplore',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Defaulting to Dark Liquid Glass
      routerConfig: goRouter,
    );
  }
}
