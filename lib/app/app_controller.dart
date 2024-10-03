import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/di.dart';
import 'package:sales/models/postgres_configurations.dart';
import 'package:sales/services/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller của App
class AppController {
  final _prefs = getIt<SharedPreferences>();

  /// Cấu hình Postgres
  PostgresConfigurations postgresConfigurations = PostgresConfigurations(
    host: 'localhost',
    database: 'postgres',
    username: 'postgres',
    password: 'sales',
  );

  /// Khởi tạo
  Future<void> initial() async {
    await getIt<Database>().initial();
    final postgresSettingsJson = _prefs.getString('PostgresSettings');
    if (postgresSettingsJson != null) {
      postgresConfigurations =
          PostgresConfigurations.fromJson(postgresSettingsJson);
    }
  }

  /// Giải phóng
  Future<void> dispose() async {
    await getIt<Database>().dispose();
  }

  /// Thay đổi cấu hình Postgres
  Future<void> changePostgresConfigurations(
    PostgresConfigurations settings,
  ) async {
    postgresConfigurations = settings;
    await _prefs.setString('PostgresSettings', settings.toJson());
  }

  /// Dialog cấu hình server
  Future<void> configuationsDialog(BuildContext context) async {
    PostgresConfigurations settings = postgresConfigurations;
    final result = await boxWDialog(
      context: context,
      title: 'Cấu Hình Máy Chủ'.tr,
      content: Column(
        children: [
          BoxWInput(
            title: 'host',
            initial: settings.host,
            onChanged: (value) {
              settings = settings.copyWith(host: value);
            },
          ),
          BoxWInput(
            title: 'database',
            initial: settings.database,
            onChanged: (value) {
              settings = settings.copyWith(database: value);
            },
          ),
          BoxWInput(
            title: 'username',
            initial: settings.username,
            onChanged: (value) {
              settings = settings.copyWith(username: value);
            },
          ),
          BoxWInput(
            title: 'password',
            initial: settings.password,
            obscureText: true,
            onChanged: (value) {
              settings = settings.copyWith(password: value);
            },
          ),
        ],
      ),
      buttons: (_) {
        return [
          Buttons(
            axis: Axis.horizontal,
            buttons: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Lưu'.tr),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Huỷ'.tr),
                ),
              ),
            ],
          ),
        ];
      },
    );

    if (result == true) {
      postgresConfigurations = settings;
      await getIt<Database>().initial();
    }
  }
}
