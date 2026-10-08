# Зертханалық сабақ №10. Қарапайым қосымшаны профилизациялау

100 элементтен тұратын ListView (мәтін + сурет). Қосымша ішінде `FrameTiming` арқылы кадр статистикасы (build / raster, jank) көрсетіледі; режимдер: баяу (`Image.network`) және оңтайлы (`CachedNetworkImage` + `memCacheWidth` + fade өшірілген). Өлшеу: `flutter build apk --profile`, эмулятор, 8 жоғары + 8 төмен жылжыту (алдын ала бір «жылыту» өтуімен).

## Іске қосу

```bash
flutter pub get
flutter analyze
flutter test
flutter run            # эмулятор / құрылғы
```

## Нәтижелер (profile режимі, Android эмуляторы)

| Режим | Кадр | build, мс | raster, мс | jank (>16.7 мс) | TOTAL PSS |
|-------|------|-----------|------------|-----------------|-----------|
| Баяу (`Image.network`) | 1641 | 0.7 | 3.3 | 139 (8.5%) | 118 MB |
| Оңтайлы (fade өшірілген) | 1811 | 0.9 | 2.8 | 73 (4.0%) | 120 MB |
| `CachedNetworkImage` (әдепкі fade) | 2254 | 0.9 | 7.1 | 769 (34.1%) | 119 MB |

Қорытынды: `CachedNetworkImage` әдепкі fade-анимациясымен өнімділікті **төмендетті** (әр кадрға қосымша жүктеме); fade-ті өшіргеннен кейін jank екі есе азайды. Жад қолдануы айтарлықтай өзгерген жоқ. Эмулятордағы абсолютті сандар нақты құрылғыдан өзгеше болуы мүмкін.

## Скриншоттар

- `../screenshots/lab10_slow.png`
- `../screenshots/lab10_optimized.png`
- `../screenshots/lab10_optimized_with_fade.png`
