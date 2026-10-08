# Зертханалық сабақ №12. APK / Bundle құрастыру, құрылғыда тексеру

`flutter build apk --release` → `app-release.apk` (44 MB), `flutter build appbundle --release` → `app-release.aab` (44 MB). APK `adb install` арқылы эмуляторға орнатылып, қосымша «Release build» режимін көрсетеді. Release қол қою — debug кілтімен (оқу мақсаты); жариялау үшін өз keystore қажет.

Көшірмелер: `../release/lab12-app-release.apk`, `../release/lab12-app-release.aab`.

## Іске қосу

```bash
flutter pub get
flutter analyze
flutter test
flutter run            # эмулятор / құрылғы
```


## Скриншоттар

- `../screenshots/lab12_build_log.png`
- `../screenshots/lab12_adb_install.png`
- `../screenshots/lab12_release_app.png`
