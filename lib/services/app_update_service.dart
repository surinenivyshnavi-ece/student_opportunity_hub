import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      final currentVersion = packageInfo.version;

      final doc = await FirebaseFirestore.instance
          .collection('app_config')
          .doc('app')
          .get();

      if (!doc.exists) return;

      final data = doc.data();

      if (data == null) return;

      final latestVersion =
          data['latestVersion']?.toString() ?? currentVersion;

      final message =
          data['updateMessage']?.toString() ??
              'A new version of the app is available.';

      final updateUrl =
          data['updateUrl']?.toString() ?? '';

      final forceUpdate =
          data['forceUpdate'] == true;

      if (_isNewerVersion(latestVersion, currentVersion)) {
        if (!context.mounted) return;

        showDialog(
          context: context,
          barrierDismissible: !forceUpdate,
          builder: (context) {
            return PopScope(
              canPop: !forceUpdate,
              child: AlertDialog(
                title: const Text(
                  '🚀 New Update Available',
                ),
                content: Text(message),
                actions: [
                  if (!forceUpdate)
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Later'),
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      if (updateUrl.isNotEmpty) {
                        final uri = Uri.parse(updateUrl);

                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      }
                    },
                    child: const Text('Update Now'),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      debugPrint('Update check failed: $e');
    }
  }

  static bool _isNewerVersion(
      String latest,
      String current,
      ) {
    final latestParts = latest.split('.');
    final currentParts = current.split('.');

    final maxLength =
    latestParts.length > currentParts.length
        ? latestParts.length
        : currentParts.length;

    for (int i = 0; i < maxLength; i++) {
      final latestNumber =
      i < latestParts.length
          ? int.tryParse(latestParts[i]) ?? 0
          : 0;

      final currentNumber =
      i < currentParts.length
          ? int.tryParse(currentParts[i]) ?? 0
          : 0;

      if (latestNumber > currentNumber) {
        return true;
      }

      if (latestNumber < currentNumber) {
        return false;
      }
    }

    return false;
  }
}