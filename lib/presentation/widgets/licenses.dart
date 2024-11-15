import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/domain/entities/license.dart';
import 'package:sales/presentation/riverpod/notifiers/login_provider.dart';
import 'package:sales/presentation/riverpod/states/login_state.dart';

Widget buildLicense(WidgetRef ref) {
  final state = ref.watch(loginProvider);
  final notifier = ref.read(loginProvider.notifier);

  return !state.isLoggedIn
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: switch (state.license) {
            ActiveLicense() => _buildActiveLicense(notifier, state),
            TrialLicense() => _buildTrialLicense(notifier, state),
            NoLicense() => _buildNoLicense(notifier, state),
          },
        );
}

Widget _buildActiveLicense(LoginNotifier notifier, LoginState state) {
  return _buildActivation(
    title: 'Bạn đang sử dụng bản quyền. Còn @{day} ngày.'.trP({
      'day': state.license.remainingDays,
    }),
    notifier: notifier,
    state: state,
    isRenew: true,
  );
}

Widget _buildTrialLicense(LoginNotifier notifier, LoginState state) {
  return state.license.isExpired
      ? _buildActivation(
          title: 'Bạn đã hết thời gian dùng thử.\nVui lòng nhập mã để kích hoạt ứng dụng'.tr,
          notifier: notifier,
          state: state,
        )
      : Column(
          children: [
            Text(
              'Bạn đang sử dụng bản dùng thử. Còn @{day} ngày.'.trP({
                'day': state.license.remainingDays,
              }),
            ),
            FilledButton(
              onPressed: null,
              child: Text('Kích Hoạt'.tr),
            ),
          ],
        );
}

FutureBuilder<bool> _buildNoLicense(LoginNotifier notifier, LoginState state) {
  return FutureBuilder<bool>(
    future: notifier.canActiveTrial(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      return snapshot.data!
          ? _buildTrialActivation(notifier, state)
          : _buildActivation(
              title: 'Bạn đã hết thời gian sử dụng.\nVui lòng nhập mã để kích hoạt ứng dụng'.tr,
              notifier: notifier,
              state: state,
            );
    },
  );
}

Column _buildTrialActivation(LoginNotifier notifier, LoginState state) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          'Bạn có 15 ngày để dùng thử.\nVui lòng nhấn Kích Hoạt để tiếp tục'.tr,
          textAlign: TextAlign.center,
        ),
      ),
      FilledButton(
        onPressed: () {
          notifier.activeTrial();
        },
        child: Text('Kích Hoạt'.tr),
      ),
      Text(
        state.licenseError,
        style: const TextStyle(color: Colors.red),
      ),
    ],
  );
}

StatefulBuilder _buildActivation({
  required String title,
  required LoginNotifier notifier,
  required LoginState state,
  bool isRenew = false,
}) {
  var code = '';
  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
          BoxWInput(
            title: 'Mã kích hoạt'.tr,
            onChanged: (value) {
              setState(() => code = value);
            },
          ),
          if (state.licenseError.isNotEmpty)
            Text(
              state.licenseError,
              style: const TextStyle(color: Colors.red),
            ),
          FilledButton(
            onPressed: code.isEmpty
                ? null
                : () {
                    if (isRenew) {
                      notifier.renew(code);
                    } else {
                      notifier.active(code);
                    }
                  },
            child: Text(isRenew ? 'Gia Hạn'.tr : 'Kích Hoạt'.tr),
          ),
        ],
      );
    },
  );
}
