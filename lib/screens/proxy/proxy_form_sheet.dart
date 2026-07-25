import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../models/proxy_config.dart';
import '../../providers/proxy_provider.dart';

class ProxyFormSheet extends StatefulWidget {
  final ProxyConfig? initialProxy;
  const ProxyFormSheet({this.initialProxy, super.key});

  @override
  State<ProxyFormSheet> createState() => _ProxyFormSheetState();
}

class _ProxyFormSheetState extends State<ProxyFormSheet> {
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _userController;
  late TextEditingController _passController;

  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController(text: widget.initialProxy?.host ?? '');
    _portController = TextEditingController(text: widget.initialProxy?.port.toString() ?? '');
    _userController = TextEditingController(text: widget.initialProxy?.username ?? '');
    _passController = TextEditingController(text: widget.initialProxy?.password ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.initialProxy == null ? 'Add Proxy' : 'Edit Proxy'),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _save,
            child: const Text('Save'),
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('SERVER', style: TextStyle(fontSize: 12, color: Color(0x99FFFFFF))),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _hostController,
                placeholder: 'Host (e.g. 1.2.3.4)',
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: _portController,
                placeholder: 'Port (e.g. 1080)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              const Text('AUTHENTICATION (OPTIONAL)', style: TextStyle(fontSize: 12, color: Color(0x99FFFFFF))),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _userController,
                placeholder: 'Username',
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: _passController,
                placeholder: 'Password',
                obscureText: true,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _save() {
    final host = _hostController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 0;
    if (host.isEmpty || port == 0) return;

    final proxy = (widget.initialProxy ?? ProxyConfig(id: const Uuid().v4(), host: '', port: 0)).copyWith(
      host: host,
      port: port,
      username: _userController.text.trim(),
      password: _passController.text.trim(),
    );

    final ref = ProviderScope.containerOf(context);
    if (widget.initialProxy == null) {
      ref.read(proxyListProvider.notifier).addProxy(proxy);
    } else {
      ref.read(proxyListProvider.notifier).updateProxy(proxy);
    }
    Navigator.pop(context);
  }
}
