import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/di.dart';
import 'package:sales/models/postgres_settings.dart';
import 'package:sales/models/views_model.dart';
import 'package:sales/services/database/database.dart';
import 'package:sales/views/dashboard.dart';
import 'package:sales/views/products.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController {
  final prefs = getIt<SharedPreferences>();
  var postgresSettings = PostgresSettings(
    host: 'localhost',
    database: 'postgres',
    username: 'postgres',
    password: 'sales',
  );

  Future<void> initial() async {
    final postgresSettingsJson = prefs.getString('PostgresSettings');
    if (postgresSettingsJson != null) {
      postgresSettings = PostgresSettings.fromJson(postgresSettingsJson);
    }
  }

  Future<void> changePostgresSettings(PostgresSettings settings) async {
    postgresSettings = settings;
    await prefs.setString('PostgresSettings', settings.toJson());
  }

  Widget getLastView() {
    return switch (
        ViewsModel.values.byName(prefs.getString('LastView') ?? 'products')) {
      ViewsModel.dashboard => const DashboardView(),
      // TODO: Bổ sung màn hình Orders
      ViewsModel.orders => throw UnimplementedError(),
      ViewsModel.products => const ProductsView(),
      // TODO: Bổ sung màn hình Report
      ViewsModel.report => throw UnimplementedError(),
      // TODO: Bổ sung màn hình Setting
      ViewsModel.setting => throw UnimplementedError(),
    };
  }

  // TODO: Bổ sung vào các Navigation để có thể lưu được trạng thái màn hình mở cối
  void setLastView(ViewsModel view) {
    prefs.setString('LastView', view.name);
  }

  void settingsDialog(BuildContext context) async {
    PostgresSettings settings = postgresSettings;
    final result = await boxWDialog(
      context: context,
      title: 'Cấu Hình Máy Chủ'.tr,
      // width: MediaQuery.sizeOf(context).width * 3 / 5,
      // constrains: BoxConstraints(
      //   minWidth: 280,
      //   maxWidth: MediaQuery.sizeOf(context).width * 3 / 5,
      // ),
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
      buttons: (ctx) {
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
      postgresSettings = settings;
      await getIt<Database>().initial();
    }
  }
}
