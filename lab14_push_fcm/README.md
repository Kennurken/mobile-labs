# Зертханалық сабақ №14. Push-хабарлама жіберу (FCM)

`firebase_core` + `firebase_messaging`: инициализация, рұқсат сұрау (Android 13+ `POST_NOTIFICATIONS`), FCM токенін экранға шығару, `onMessage` және фондық handler.

Firebase жобасы: `mobile-labs`, Android қосымшасы `kz.labs.lab14_push_fcm`. `google-services.json` `android/app/` ішінде (Gradle плагині файл болғанда ғана қосылады). Эмуляторда токен алынды және Firebase Console-дан жіберілген тест-хабарлама екі жағдайда да қабылданды: қосымша ашық кезде — экрандағы тізімде, қосымша жабық (фонда) кезде — жүйелік notification панелінде. Хабарлама жіберу: Firebase Console → Messaging → «Send test message» → токенді қою.

> `google-services.json` жеке жобаның конфигурациясы — қоғамдық репозиторийге жүктемеңіз.

## Іске қосу

```bash
flutter pub get
flutter analyze
flutter test
flutter run            # эмулятор / құрылғы
```


## Скриншоттар

- `../screenshots/lab14_token.png` (токен алынды)
- `../screenshots/lab14_message_foreground.png` (қосымша ашық: хабарлама тізімде)
- `../screenshots/lab14_notification_shade.png` (қосымша фонда: жүйелік хабарлама)
- `../screenshots/lab14_no_firebase.png` (конфигсіз күй)

> Ескерту: Android принудительно тоқтатылған (force-stop) қосымшаға FCM жеткізбейді — қосымшаны бір рет ашып, содан кейін ғана жабыңыз/жасырыңыз.
