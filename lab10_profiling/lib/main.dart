// Зертханалық сабақ №10. Қарапайым қосымшаны профилизациялау.
// 100 элементтен тұратын ListView (мәтін + кішкентай сурет).
// Режимдер: «Баяу» (Image.network, оңтайландырусыз) және
// «Оңтайлы» (CachedNetworkImage + кэш өлшемі + ListView.builder lazy loading).
// Профилизация: flutter run --profile, DevTools және қосымша ішіндегі FrameTiming статистикасы.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const itemCount = 100;

/// Сурет URL-ы: 100 әртүрлі кішкентай сурет.
String thumbUrl(int i) => 'https://picsum.photos/120/120?random=$i';

/// Кадр уақытын өлшеу (FPS профилизациясы): FrameTiming → build / raster ұзақтығы.
class FrameStats extends ChangeNotifier {
  int frames = 0;
  int jank = 0; // 16.7 мс бюджеттен асқан кадрлар
  int worstUs = 0;
  int _buildUs = 0;
  int _rasterUs = 0;

  double get avgBuildMs => frames == 0 ? 0 : _buildUs / frames / 1000;
  double get avgRasterMs => frames == 0 ? 0 : _rasterUs / frames / 1000;
  double get jankPercent => frames == 0 ? 0 : jank * 100 / frames;

  void start() => SchedulerBinding.instance.addTimingsCallback(_onTimings);

  void _onTimings(List<FrameTiming> timings) {
    for (final t in timings) {
      frames++;
      _buildUs += t.buildDuration.inMicroseconds;
      _rasterUs += t.rasterDuration.inMicroseconds;
      final total = t.totalSpan.inMicroseconds;
      if (total > worstUs) worstUs = total;
      if (total > 16667) jank++;
    }
    notifyListeners();
  }

  void reset() {
    frames = jank = worstUs = _buildUs = _rasterUs = 0;
    notifyListeners();
  }
}

final frameStats = FrameStats();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  frameStats.start();
  runApp(const ProfileDemoApp());
}

class ProfileDemoApp extends StatefulWidget {
  const ProfileDemoApp({super.key});

  @override
  State<ProfileDemoApp> createState() => _ProfileDemoAppState();
}

class _ProfileDemoAppState extends State<ProfileDemoApp> {
  bool overlay = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Demo App',
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: overlay, // Performance Overlay: FPS графигі
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: ProfilePage(
        overlay: overlay,
        onOverlayChanged: () => setState(() => overlay = !overlay),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.overlay,
    required this.onOverlayChanged,
  });
  final bool overlay;
  final VoidCallback onOverlayChanged;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool optimized = false;

  Widget _thumb(int i) {
    if (optimized) {
      return CachedNetworkImage(
        imageUrl: thumbUrl(i),
        width: 56,
        height: 56,
        memCacheWidth: 112, // декодтау өлшемін шектеу → жад үнемдейді
        fadeInDuration:
            Duration.zero, // fade-анимация әр кадрға қосымша жүктеме береді
        fadeOutDuration: Duration.zero,
        fit: BoxFit.cover,
        placeholder: (_, _) => const SizedBox(
          width: 56,
          height: 56,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (_, _, _) => const Icon(Icons.broken_image),
      );
    }
    return Image.network(
      thumbUrl(i),
      width: 56,
      height: 56,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(optimized ? 'Профиль: оңтайлы' : 'Профиль: баяу'),
        actions: [
          IconButton(
            tooltip: 'Performance Overlay',
            icon: Icon(widget.overlay ? Icons.speed : Icons.speed_outlined),
            onPressed: widget.onOverlayChanged,
          ),
        ],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: frameStats,
        builder: (context, _) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Кадр: ${frameStats.frames}  ·  build ${frameStats.avgBuildMs.toStringAsFixed(1)} мс  ·  '
                    'raster ${frameStats.avgRasterMs.toStringAsFixed(1)} мс\n'
                    'jank: ${frameStats.jank} (${frameStats.jankPercent.toStringAsFixed(1)}%)  ·  '
                    'ең баяу кадр: ${(frameStats.worstUs / 1000).toStringAsFixed(1)} мс',
                    key: const Key('stats'),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: frameStats.reset,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Оңтайландыру (CachedNetworkImage)'),
            value: optimized,
            onChanged: (v) => setState(() => optimized = v),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itemCount,
              itemBuilder: (_, i) => ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _thumb(i),
                ),
                title: Text('Элемент №${i + 1}'),
                subtitle: Text('Сурет: lab10_$i'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
