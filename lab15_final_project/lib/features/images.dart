// Зертханалық сабақ №7. Суреттерді фондық режимде жүктеу.
// Image.network (URL) + loadingBuilder (Loading Indicator) + GridView/ListView.
import 'package:flutter/material.dart';

/// Image Network + Show Loading Indicator.
class NetworkPhoto extends StatelessWidget {
  const NetworkPhoto(this.url, {super.key, this.height});
  final String url;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      height: height,
      fit: BoxFit.cover,
      // Бірінші кадр келгенге дейін (байттар әлі жоқ) индикатор көрсетіледі
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return SizedBox(
          height: height,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      // Сурет жүктелмей тұрғанда Progress Bar көрсетіледі
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        final total = progress.expectedTotalBytes;
        return SizedBox(
          height: height,
          child: Center(
            child: CircularProgressIndicator(
              value: total == null ? null : progress.cumulativeBytesLoaded / total,
            ),
          ),
        );
      },
      errorBuilder: (_, _, _) => SizedBox(
        height: height,
        child: const Center(child: Icon(Icons.broken_image, size: 40)),
      ),
    );
  }
}

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  // Refresh Page: seed өзгергенде барлық URL жаңарады → жаңа кездейсоқ суреттер
  int _seed = 0;

  void _refresh() => setState(() => _seed += 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Async Image Loader')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: NetworkPhoto(
                'https://picsum.photos/400/300?random=$_seed',
                height: 200,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 9,
              itemBuilder: (_, i) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: NetworkPhoto(
                  'https://picsum.photos/200/200?random=${_seed + i + 1}',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: FilledButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Жаңа суреттер жүктеу'),
            ),
          ),
        ],
      ),
    );
  }
}
