import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/directory_item.dart';
import '../services/directory_service.dart';
import 'proxy_provider.dart';
import '../core/constants/app_constants.dart';

final directoryServiceProvider = Provider((ref) => DirectoryService());

final currentUrlProvider = StateProvider<String>((ref) => AppConstants.defaultBrowserUrl);

final directoryItemsProvider = FutureProvider<List<DirectoryItem>>((ref) async {
  final service = ref.watch(directoryServiceProvider);
  final url = ref.watch(currentUrlProvider);
  final proxyList = ref.watch(proxyListProvider.notifier);
  
  service.configureProxy(proxyList.activeProxy);
  
  return await service.fetchDirectory(url);
});

final breadcrumbsProvider = Provider<List<String>>((ref) {
  final url = ref.watch(currentUrlProvider);
  final uri = Uri.parse(url);
  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  
  List<String> crumbs = [AppConstants.defaultBrowserUrl];
  String current = AppConstants.defaultBrowserUrl;
  if (!current.endsWith('/')) current += '/';
  
  for (final segment in segments) {
    current += '$segment/';
    crumbs.add(current);
  }
  return crumbs;
});
