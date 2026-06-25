import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/proxy_config.dart';
import '../../providers/proxy_provider.dart';
import '../../core/theme/app_theme.dart';
import 'proxy_form_sheet.dart';

class ProxyScreen extends ConsumerWidget {
  const ProxyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proxies = ref.watch(proxyListProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('SOCKS5 Proxy'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () => _showForm(context),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Configure SOCKS5 proxies to route your browser traffic and downloads securely.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0x99FFFFFF)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: proxies.length,
                itemBuilder: (context, index) {
                  final proxy = proxies[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: AppTheme.glassDecoration(brightness: Brightness.dark),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.shield_fill,
                          color: proxy.isEnabled ? CupertinoColors.activeGreen : CupertinoColors.systemGrey,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\${proxy.host}:\${proxy.port}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              if (proxy.username.isNotEmpty)
                                Text('User: \${proxy.username}', style: const TextStyle(fontSize: 12, color: Color(0x66FFFFFF))),
                            ],
                          ),
                        ),
                        CupertinoSwitch(
                          value: proxy.isEnabled,
                          onChanged: (_) => ref.read(proxyListProvider.notifier).toggleProxy(proxy.id),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Icon(CupertinoIcons.ellipsis_vertical),
                          onPressed: () => _showActions(context, ref, proxy),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showForm(BuildContext context, {ProxyConfig? proxy}) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => const ProxyFormSheet(initialProxy: proxy),
    );
  }

  void _showActions(BuildContext context, WidgetRef ref, ProxyConfig proxy) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => const CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showForm(context, proxy: proxy);
            },
            child: const Text('Edit'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              ref.read(proxyListProvider.notifier).deleteProxy(proxy.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}
