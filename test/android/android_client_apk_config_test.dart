import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android app label and launcher icon resources are client-ready', () {
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();

    expect(manifest, contains('android:label="Promoo"'));
    expect(manifest, contains('android:icon="@mipmap/ic_launcher"'));
    expect(manifest, contains('android:roundIcon="@mipmap/ic_launcher_round"'));
    expect(
      manifest,
      contains('android.permission.INTERNET'),
      reason: 'Release APK needs Internet permission for remote demo imagery.',
    );

    for (final density in const [
      'mipmap-mdpi',
      'mipmap-hdpi',
      'mipmap-xhdpi',
      'mipmap-xxhdpi',
      'mipmap-xxxhdpi',
    ]) {
      _expectPngExists('android/app/src/main/res/$density/ic_launcher.png');
      _expectPngExists(
        'android/app/src/main/res/$density/ic_launcher_round.png',
      );
      _expectPngExists(
        'android/app/src/main/res/$density/ic_launcher_foreground.png',
      );
    }

    expect(
      File(
        'android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml',
      ).existsSync(),
      isTrue,
    );
    expect(
      File(
        'android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml',
      ).existsSync(),
      isTrue,
    );
  });
}

void _expectPngExists(String path) {
  final file = File(path);
  expect(file.existsSync(), isTrue, reason: '$path should exist.');
  expect(
    file.lengthSync(),
    greaterThan(0),
    reason: '$path should be nonempty.',
  );
}
