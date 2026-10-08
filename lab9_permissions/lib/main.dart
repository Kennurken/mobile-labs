// Зертханалық сабақ №9. Рұқсаттармен жұмыс (камера, жад/галерея).
// «Камераны ашу» → Take Photo, «Жадтан сурет таңдау» → Photo Library.
// Рұқсат берілмесе — «Рұқсат берілмеді!» Snackbar.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Рұқсат + сурет алу қызметі (тестте ауыстыруға болады).
abstract class MediaService {
  /// Сурет файлының жолын қайтарады; рұқсат жоқ болса null.
  Future<String?> takePhoto();
  Future<String?> pickFromGallery();
}

class DeviceMediaService implements MediaService {
  final _picker = ImagePicker();

  @override
  Future<String?> takePhoto() async {
    final status = await Permission.camera.request(); // Camera рұқсаты
    if (!status.isGranted) return null;
    return (await _picker.pickImage(source: ImageSource.camera))?.path;
  }

  @override
  Future<String?> pickFromGallery() async {
    // Android 13+ жүйелік Photo Picker рұқсатсыз жұмыс істейді,
    // ескі нұсқаларда READ_EXTERNAL_STORAGE қажет — Permission.photos екеуін де жабады.
    final status = await Permission.photos.request();
    if (!status.isGranted && !status.isLimited) {
      // Photo Picker рұқсатты талап етпейді: сұраныс қайтарылса да таңдауға болады
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      return picked?.path;
    }
    return (await _picker.pickImage(source: ImageSource.gallery))?.path;
  }
}

void main() => runApp(PermissionsApp(service: DeviceMediaService()));

class PermissionsApp extends StatelessWidget {
  const PermissionsApp({super.key, required this.service});
  final MediaService service;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Permissions Demo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: PermissionsPage(service: service),
    );
  }
}

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key, required this.service});
  final MediaService service;

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  String? _imagePath;

  Future<void> _run(Future<String?> Function() action) async {
    final path = await action();
    if (!mounted) return;
    if (path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Рұқсат берілмеді!')),
      );
      return;
    }
    setState(() => _imagePath = path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions Page')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: () => _run(widget.service.takePhoto),
              icon: const Icon(Icons.photo_camera),
              label: const Text('Камераны ашу'),
            ),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: () => _run(widget.service.pickFromGallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Жадтан сурет таңдау'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: _imagePath == null
                    ? const Text('Сурет таңдалмаған')
                    : Image.file(File(_imagePath!), key: const Key('picked')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
