import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/presentation/riverpod/notifiers/settings_provider.dart';
import 'package:sales/presentation/riverpod/states/settings_state.dart';

/// Màn hình cài đặt.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(settingsProvider.notifier);
    final state = ref.watch(settingsProvider);

    if (state.isLoading) {
      return const SizedBox.shrink();
    }

    if (state.error.isNotEmpty) {
      return Center(child: Text(state.error));
    }

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLanguage(notifier, state),
              _buildBrightness(notifier, state),
              _buildSaveLastView(notifier, state),
              _buildItemPerPage(notifier, state),
              _buildBackupRestore(notifier, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguage(SettingsNotifier notifier, SettingsState state) {
    return ListTile(
      leading: const Icon(Icons.language_rounded),
      title: Text('Ngôn Ngữ'.tr),
      trailing: SizedBox(
        width: 200,
        child: BoxWDropdown<LanguageCodes>(
          margin: EdgeInsets.zero,
          items: state.supportedLanguages.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e.nativeName),
            );
          }).toList(),
          value: state.currentlanguage,
          onChanged: (value) async {
            if (value != null) {
              await notifier.changeLanguage(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildBrightness(SettingsNotifier notifier, SettingsState state) {
    return ListTile(
      leading: const Icon(Icons.dark_mode_rounded),
      title: Text('Chế Độ Tối'.tr),
      trailing: Checkbox(
        value: state.brightness == Brightness.dark,
        onChanged: (value) async {
          if (value != null) {
            await notifier.setBrightness(value == true ? Brightness.dark : Brightness.light);
          }
        },
      ),
    );
  }

  Widget _buildSaveLastView(SettingsNotifier notifier, SettingsState state) {
    return ListTile(
      leading: const Icon(Icons.bookmark_rounded),
      title: Text('Lưu màn hình cuối cho lần mở tiếp theo'.tr),
      subtitle: Text('Mặc định sẽ mở trang Tổng Quan'.tr),
      trailing: Checkbox(
        value: state.saveLastView,
        onChanged: (value) async {
          if (value != null) {
            await notifier.toggleSaveLastView();
          }
        },
      ),
    );
  }

  Widget _buildItemPerPage(SettingsNotifier notifier, SettingsState state) {
    return ListTile(
      leading: const Icon(Icons.horizontal_split_rounded),
      title: Text('Số dòng mỗi trang khi phân trang'.tr),
      trailing: SizedBox(
        width: 100,
        child: BoxWNumberField(
          initial: state.itemPerPage,
          min: 1,
          onChanged: (value) async {
            if (value != null) {
              await notifier.updateItemPerPage(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildBackupRestore(SettingsNotifier notifier, SettingsState state) {
    return ListTile(
      leading: const Icon(Icons.backup_rounded),
      title: Text('Sao Lưu và Khôi Phục'.tr),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton(
            onPressed: () {
              notifier.backup();
            },
            child: Text('Sao Lưu'.tr),
          ),
          const SizedBox(width: 6),
          FilledButton(
            onPressed: () {
              notifier.restore();
            },
            child: Text('Khôi Phục'.tr),
          ),
        ],
      ),
    );
  }
}
