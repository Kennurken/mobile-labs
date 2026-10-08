# mobile-labs — Flutter-лабораторные (курс «Мобильные приложения», Android Studio)

15 лабораторных работ по методичке УМКД «Мобильді қондырғылар үшін қосымшаны құру». Все работы на **Flutter/Dart**, целевая платформа — **Android**. Каждая лаба — отдельный Flutter-проект со своим `README.md` (на казахском), тестами и скриншотами в [`screenshots/`](screenshots).

| № | Проект | Тема | Что нужно кроме Flutter |
|---|--------|------|--------------------------|
| 1 | `lab1_hello_world` | Hello World | — |
| 2 | `lab2_data_input` | Экран: кнопка, текст, ввод данных | — |
| 3 | `lab3_multi_screen` | Несколько экранов, навигация | — |
| 4 | `lab4_user_settings` | Логин и тёмная тема (App State, `shared_preferences`) | — |
| 5 | `lab5_todo_crud` | ToDo: Create / Read / Update / Delete (локальное хранилище) | — |
| 6 | `lab6_api_cat_facts` | REST API: Cat Facts, Random User | интернет |
| 7 | `lab7_async_images` | Асинхронная загрузка картинок | интернет |
| 8 | `lab8_geolocation` | Геолокация (`geolocator`) | GPS / эмулятор с координатами |
| 9 | `lab9_permissions` | Камера и галерея, разрешения | камера (виртуальная в эмуляторе) |
| 10 | `lab10_profiling` | Профилирование списка (FPS, jank) | интернет, режим `--profile` |
| 11 | `lab11_unit_tests` | Unit-тесты | — |
| 12 | `lab12_apk_build` | Сборка release APK / AAB | — |
| 13 | `lab13_counter_app` | Кроссплатформенный счётчик (Android + web) | Chrome для web |
| 14 | `lab14_push_fcm` | Push-уведомления (FCM) | **свой** Firebase-проект + `google-services.json` |
| 15 | `lab15_final_project` | Итоговый проект + экран самопроверки | Firebase (для push), все разрешения |

Лабы 1–3 созданы раньше остальных; лабы 4–15 — по порядку методички.

---

## 1. Что проверено, а что нет

| Среда | Статус |
|-------|--------|
| **macOS 27 (Apple Silicon, arm64), 16 ГБ RAM**, Flutter 3.47.3 / Dart 3.13.3, Android Studio 2026.1, эмулятор Android 16 (API 36) | ✅ лабы **4–15** собраны, запущены на эмуляторе и проверены (`flutter test` и `flutter analyze` зелёные, скриншоты в `screenshots/`). Лабы 1–3 сделаны раньше и в этой проверке заново не гонялись |
| Реальное Android-устройство | ❌ не проверялось (только эмулятор) |
| **Windows 10/11, Linux** | ⚠️ **не проверялось.** Инструкции ниже составлены по официальной документации Flutter/Android; в коде Android-части нет ничего, что привязано к macOS, но реальный запуск на этих системах я не делал |
| iOS | ❌ не поддерживается в этом репозитории (в проектах только папка `android/`; в `lab13_counter_app` есть заготовка `ios/`, но она не запускалась — на машине нет Xcode) |

Если что-то не заработало на Windows/Linux — это ожидаемый риск, смотри раздел [«Частые проблемы»](#6-частые-проблемы).

---

## 2. Что нужно установить (по ОС)

Версии, на которых всё проверено (в скобках — что допустимо, но не проверялось):

| Компонент | Версия |
|-----------|--------|
| Flutter SDK (stable) | 3.47.3 (Dart 3.13.3 — в `pubspec.yaml` требуется `sdk: ^3.13.3`, так что **Flutter не старше 3.47**) |
| Android Studio | 2026.1 (JDK берётся из встроенного JetBrains Runtime — отдельный JDK ставить не нужно) |
| Android SDK Platform | **36** (Android 16) |
| Android SDK Build-Tools | 36.0.0 |
| Android SDK Command-line Tools, Platform-Tools, Emulator | последние |
| Android NDK | 28.2.13676358 (Gradle скачает сам после принятия лицензий) |
| Gradle / Android Gradle Plugin / Kotlin | 9.3.1 / 9.1.0 / 2.4.0 (скачиваются автоматически, ставить вручную не надо) |
| Git | любой свежий |

### Минимальные требования к машине

| | Windows 10/11 (64-бит) | macOS | Linux (x86-64, Ubuntu 22.04+) |
|---|---|---|---|
| ОЗУ | 8 ГБ минимум, **16 ГБ рекомендуется** (эмулятор + Gradle) | то же | то же |
| Диск | ~**25 ГБ** свободно (Flutter ≈ 4 ГБ, Android SDK ≈ 10 ГБ, Gradle-кэш ≈ 8 ГБ, образ эмулятора ≈ 2 ГБ, сборки проектов) | то же | то же |
| Виртуализация для эмулятора | включить в BIOS **VT-x / AMD-V** и компонент Windows **«Платформа гипервизора Windows» (Windows Hypervisor Platform)** | Hypervisor.framework (есть из коробки) | **KVM** (`sudo apt install qemu-kvm`, пользователь в группе `kvm`) |
| Образ эмулятора | `x86_64` (Intel/AMD) | Apple Silicon → `arm64-v8a`; Intel Mac → `x86_64` | `x86_64` |
| Дополнительно | **Режим разработчика** Windows (нужен Flutter-плагинам для symlink): *Параметры → Конфиденциальность и безопасность → Для разработчиков → Режим разработчика* или `start ms-settings:developers` | — | пакеты `curl git unzip xz-utils zip libglu1-mesa` |

> Без аппаратной виртуализации эмулятор не запустится или будет работать мучительно медленно. В этом случае используй **реальный телефон** с включённой отладкой по USB.

### Установка по шагам

#### Windows 10/11

1. Установи **Git for Windows**: https://git-scm.com/download/win (или `winget install Git.Git`).
2. Скачай **Flutter SDK** (stable) с https://docs.flutter.dev/install , распакуй в `C:\src\flutter` (**не** в `C:\Program Files` и не в путь с пробелами/кириллицей) и добавь `C:\src\flutter\bin` в переменную `PATH`.
3. Установи **Android Studio**: https://developer.android.com/studio . При первом запуске выбери *Standard*-установку.
4. В Android Studio: *More Actions → SDK Manager*:
   - вкладка **SDK Platforms** → отметь **Android 16 (API 36)**;
   - вкладка **SDK Tools** → отметь **Android SDK Build-Tools 36**, **Android SDK Command-line Tools (latest)**, **Android Emulator**, **Android SDK Platform-Tools**, **NDK (Side by side)** (желательно версию 28.2.13676358).
5. Включи **Режим разработчика** Windows (см. таблицу выше) и компонент **Windows Hypervisor Platform** (*Включение или отключение компонентов Windows*), перезагрузи ПК.
6. В PowerShell:
   ```powershell
   flutter config --android-sdk "$env:LOCALAPPDATA\Android\Sdk"   # если flutter не нашёл SDK сам
   flutter doctor --android-licenses     # на все вопросы ответь y
   flutter doctor -v                     # в разделе Android toolchain должны быть галочки
   ```

#### macOS (Apple Silicon или Intel)

```bash
brew install --cask flutter android-studio      # или поставь вручную с сайтов
# дальше в Android Studio поставь SDK Platform 36, Build-Tools 36, Command-line Tools, Emulator, Platform-Tools, NDK — см. шаг 4 для Windows
flutter doctor --android-licenses
flutter doctor -v
```

Для iOS/macOS-сборок нужен ещё Xcode, но **для этих лаб он не требуется**.

#### Linux (Ubuntu / Debian)

```bash
sudo apt update && sudo apt install -y curl git unzip xz-utils zip libglu1-mesa qemu-kvm
sudo adduser $USER kvm          # затем перелогинься
# Flutter: https://docs.flutter.dev/install  (или: sudo snap install flutter --classic)
# Android Studio: https://developer.android.com/studio (распаковать и запустить studio.sh)
# в SDK Manager поставь те же компоненты, что в шаге 4 для Windows
flutter doctor --android-licenses
flutter doctor -v
```

### Эмулятор (виртуальный телефон)

В Android Studio: *Device Manager → Create Device* → любой Pixel (например Pixel 8) → системный образ:

- Intel/AMD Windows, Linux, Intel Mac → **API 36, `x86_64`, «Google APIs»**;
- Apple Silicon Mac → **API 36, `arm64-v8a`, «Google APIs»**.

⚠️ **Нужен образ именно «Google APIs»** (с Google Play Services) — на «чистом» AOSP-образе не заработают лабы 8 (запрос точности геолокации) и 14–15 (FCM).

Из командной строки (пример для Apple Silicon; на x86 замени `arm64-v8a` на `x86_64`):

```bash
sdkmanager "system-images;android-36;google_apis;arm64-v8a"
avdmanager create avd -n lab_pixel -k "system-images;android-36;google_apis;arm64-v8a" -d pixel_8
emulator -avd lab_pixel
flutter devices        # эмулятор должен появиться в списке
```

---

## 3. Запуск

```bash
git clone https://github.com/Kennurken/mobile-labs.git mobile-labs
cd mobile-labs/lab4_user_settings      # любая лаба
flutter pub get
flutter analyze
flutter test
flutter run                            # на запущенном эмуляторе или телефоне
```

> **Первая сборка очень долгая** (на проверенной машине — около 8 минут: Gradle скачивает Gradle 9.3.1, плагины, NDK и зависимости, всего несколько ГБ). Последующие — 30–90 секунд. Нужен стабильный интернет.

### Запустить тесты всех лаб сразу

macOS / Linux:

```bash
for d in lab*/; do (cd "$d" && echo "== $d" && flutter test); done
```

Windows PowerShell:

```powershell
Get-ChildItem -Directory lab* | ForEach-Object { Push-Location $_; Write-Host "== $_"; flutter test; Pop-Location }
```

---

## 4. Особенности отдельных лаб

| Лаба | Как проверить / что учесть |
|------|----------------------------|
| **8 Геолокация** | В эмуляторе задай координаты: *Extended controls (⋯) → Location → Set location* или `adb emu geo fix <долгота> <широта>` (например `71.4704 51.1605` — Астана). При первом нажатии появятся системные диалоги разрешения и «Location Accuracy» — разреши. |
| **9 Разрешения** | «Камераны ашу» открывает камеру; в эмуляторе это виртуальная сцена. Для «Жадтан сурет таңдау» нужны картинки в галерее эмулятора (перетащи файл на окно эмулятора). Отказ в разрешении показывает Snackbar «Рұқсат берілмеді!». |
| **10 Профилирование** | Цифры FPS/jank осмысленны только в режиме **profile**: `flutter run --profile` (в debug они завышены). Переключатель «Оңтайландыру» сравнивает `Image.network` и `CachedNetworkImage`. Результаты замеров — в `lab10_profiling/README.md`. |
| **12 Сборка** | `flutter build apk --release` → `build/app/outputs/flutter-apk/app-release.apk`; `flutter build appbundle --release` → `build/app/outputs/bundle/release/app-release.aab`. Подпись — **debug-ключом** (для учёбы). Для публикации в Google Play нужен собственный keystore (`keytool -genkey ...` и `key.properties`). |
| **13 Кроссплатформа** | `flutter run -d chrome` (web) и `flutter run` (Android). Папка `ios/` есть, но iOS-сборка требует macOS + Xcode и не проверялась. |
| **14–15 Push (FCM)** | Требуют **собственный Firebase-проект** — см. раздел 5. Без `google-services.json` приложение запустится и честно покажет «Firebase бапталмаған». |
| **15 Итоговый** | Экран «Финалдық тексеріс» автоматически проверяет логин, CRUD, API, GPS, разрешения камеры/галереи, Firebase и режим сборки. Чтобы получить 8/8: выдай разрешения (adb: `adb shell pm grant kz.labs.lab15_final_project android.permission.CAMERA` и т. д.) и подложи `google-services.json`; режим **Release** (`flutter run --release`) даёт последний пункт. |

---

## 5. Firebase для лаб 14 и 15

`google-services.json` в репозиторий **не включён** (это конфигурация личного проекта). Сделай свой:

1. https://console.firebase.google.com → **Create a project** (Google Analytics можно отключить).
2. В проекте: **Add app → Android** и зарегистрируй **два** приложения с точными именами пакетов:
   - `kz.labs.lab14_push_fcm`
   - `kz.labs.lab15_final_project`
3. Скачай `google-services.json` (он общий для проекта и содержит оба приложения) и положи копию в:
   - `lab14_push_fcm/android/app/google-services.json`
   - `lab15_final_project/android/app/google-services.json`
4. Пересобери (`flutter run`). Gradle-плагин Google Services подключается **автоматически, только если файл существует**.
5. В приложении лабы 14 разреши уведомления (Android 13+) — на экране появится **FCM-токен**.
6. Отправка: Firebase Console → **Messaging → Create your first campaign → Firebase Notification messages** → заголовок и текст → **Send test message** → вставь токен → **Test**.
   - Приложение **открыто** → сообщение появится в списке на экране (обработчик `onMessage`).
   - Приложение **свёрнуто** (запущено и закрыто кнопкой Home) → уведомление придёт в системную шторку.

⚠️ Android **не доставляет** FCM в приложение, которое остановлено принудительно (`force-stop`, «Остановить» в настройках, свайп в некоторых оболочках): сначала открой приложение хотя бы раз, потом сворачивай.

⚠️ Не публикуй свой `google-services.json` в открытый репозиторий — он уже в `.gitignore`.

---

## 6. Частые проблемы

| Симптом | Причина / решение |
|---------|-------------------|
| `Failed to find target with hash string 'android-37'` в лабе 9/15 | Пакет `permission_handler` 13.x требует Android SDK 37. В проектах закреплена версия **12.0.1** (`permission_handler: 12.0.1` в `pubspec.yaml`) — не обновляй до 13, пока не поставишь платформу 37. |
| `Android license status unknown` / `licenses not accepted` | `flutter doctor --android-licenses`, ответь `y` на все вопросы. |
| Эмулятор не стартует, «HAXM / hypervisor / KVM» | Включи виртуализацию в BIOS и Windows Hypervisor Platform (Windows) или KVM (Linux), перезагрузись. |
| Эмулятор без интернета (DNS не резолвит, картинки/API не грузятся) | Запусти эмулятор с явным DNS: `emulator -avd lab_pixel -dns-server 8.8.8.8,1.1.1.1`. |
| `Building with plugins requires symlink support` (Windows) | Включи **Режим разработчика** Windows. |
| `Daemon compilation failed … this and base files have different roots` (Windows) | Проект и кэш Pub (`%LOCALAPPDATA%\Pub\Cache`) лежат на разных дисках — ошибка инкрементальной компиляции Kotlin. В проектах уже стоит `kotlin.incremental=false` (`android/gradle.properties`); для своих проектов добавь эту строку или перенеси кэш на тот же диск: `setx PUB_CACHE D:\pub-cache`. Подтверждено в CI. |
| Сборка падает на длинных путях (Windows) | Клонируй репозиторий в короткий путь вроде `C:\dev\mobile-labs`; при необходимости включи длинные пути: `git config --system core.longpaths true`. |
| Предупреждения про «Built-in Kotlin» в логе Gradle | Это предупреждения плагинов, на сборку не влияют. |
| `flutter run` в лабе 14: «Failed to load FirebaseOptions from resource» | Нет `google-services.json` в `android/app/` (или имя пакета в нём не совпадает) — раздел 5. |
| Push не приходит в свёрнутое приложение | Приложение остановлено принудительно либо образ эмулятора без Google Play Services — раздел 2 и 5. |
| Первая сборка «зависла» | Это нормально для первых 5–10 минут (загрузка Gradle/SDK). Смотри `flutter run -v`. |

---

## 7. Структура репозитория

```
mobile-labs/
├── lab1_hello_world … lab15_final_project/   # Flutter-проекты (lib/, test/, android/, pubspec.yaml, README.md)
├── screenshots/                              # скриншоты с эмулятора для отчётов
└── .gitignore                                # release-файлы, google-services.json, build-каталоги не коммитятся
```

Release-файлы (`*.apk`, `*.aab`) не хранятся в git — собираются командами из лабы 12.
