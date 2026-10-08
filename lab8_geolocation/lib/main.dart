// Зертханалық сабақ №8. Геолокация: экранда координаттарды шығару.
// Location Permission сұралады, Get Current User Location → latitude / longitude.
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Орналасуды алу қызметі (тестте ауыстыруға болады).
abstract class LocationService {
  Future<({double latitude, double longitude})> getCurrent();
}

class DeviceLocationService implements LocationService {
  @override
  Future<({double latitude, double longitude})> getCurrent() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw 'GPS өшірулі. Орналасу қызметін қосыңыз.';
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // рұқсат сұрау
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw 'Рұқсат берілмеді!';
    }
    final p = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    return (latitude: p.latitude, longitude: p.longitude);
  }
}

void main() => runApp(GeoApp(service: DeviceLocationService()));

class GeoApp extends StatelessWidget {
  const GeoApp({super.key, required this.service});
  final LocationService service;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoLocation App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: LocationPage(service: service),
    );
  }
}

class LocationPage extends StatefulWidget {
  const LocationPage({super.key, required this.service});
  final LocationService service;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  // Local State Variables: latitude, longitude (Double)
  double? latitude;
  double? longitude;
  String? error;
  bool loading = false;

  Future<void> _getLocation() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final pos = await widget.service.getCurrent();
      latitude = pos.latitude;
      longitude = pos.longitude;
    } catch (e) {
      error = e.toString();
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    const big = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
    return Scaffold(
      appBar: AppBar(title: const Text('Location Page')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, size: 64, color: Colors.indigo),
            const SizedBox(height: 16),
            Text('Latitude: ${latitude?.toStringAsFixed(6) ?? '—'}', style: big),
            const SizedBox(height: 8),
            Text('Longitude: ${longitude?.toStringAsFixed(6) ?? '—'}', style: big),
            const SizedBox(height: 24),
            if (loading)
              const CircularProgressIndicator()
            else
              FilledButton.icon(
                onPressed: _getLocation,
                icon: const Icon(Icons.my_location),
                label: const Text('Координаттарды алу'),
              ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
          ],
        ),
      ),
    );
  }
}
