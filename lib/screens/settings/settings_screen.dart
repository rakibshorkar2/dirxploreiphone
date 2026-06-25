import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('DOWNLOADS'),
            _buildSettingsItem(
              'Concurrent Downloads',
              trailing: Text('${settings.concurrentDownloads}', style: const TextStyle(color: Color(0x99FFFFFF))),
              onTap: () => _showPicker(context, ref, 'Concurrent Downloads', 1, 10, settings.concurrentDownloads, (val) {
                ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(concurrentDownloads: val));
              }),
            ),
            _buildSettingsItem(
              'Max Retries',
              trailing: Text('${settings.retryCount}', style: const TextStyle(color: Color(0x99FFFFFF))),
              onTap: () => _showPicker(context, ref, 'Max Retries', 0, 20, settings.retryCount, (val) {
                ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(retryCount: val));
              }),
            ),
            _buildSettingsItem(
              'Auto Resume',
              trailing: CupertinoSwitch(
                value: settings.autoResume,
                onChanged: (val) {
                  ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(autoResume: val));
                },
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('NOTIFICATIONS'),
            _buildSettingsItem(
              'Show Notifications',
              trailing: CupertinoSwitch(
                value: settings.showNotifications,
                onChanged: (val) {
                  ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(showNotifications: val));
                },
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('APPEARANCE'),
            _buildSettingsItem(
              'Theme',
              trailing: Text(settings.themeMode.toUpperCase(), style: const TextStyle(color: Color(0x99FFFFFF))),
              onTap: () => _showThemePicker(context, ref, settings),
            ),
            const SizedBox(height: 48),
            const Center(
              child: Text(
                'DirXplore v1.0.0\nBuilt for iOS',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0x33FFFFFF)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 12, color: Color(0x66FFFFFF), fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSettingsItem(String title, {Widget? trailing, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: AppTheme.glassDecoration(brightness: Brightness.dark),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context, WidgetRef ref, String title, int min, int max, int current, Function(int) onSelected) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: AppTheme.darkSurface,
        child: Column(
          children: [
            _buildPickerHeader(context, title),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(initialItem: current - min),
                onSelectedItemChanged: (index) => onSelected(index + min),
                children: List.generate(max - min + 1, (index) => Center(child: Text('\${index + min}'))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, dynamic settings) {
    final themes = ['dark', 'light'];
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Select Theme'),
        actions: themes.map((t) => CupertinoActionSheetAction(
          onPressed: () {
            ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(themeMode: t));
            Navigator.pop(context);
          },
          child: Text(t.toUpperCase()),
        )).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  Widget _buildPickerHeader(BuildContext context, String title) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x33FFFFFF), width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(context)),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          CupertinoButton(child: const Text('Done'), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
