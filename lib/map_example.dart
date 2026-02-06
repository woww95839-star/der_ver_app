import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// 📍 Exemples avancés d'utilisation de Flutter Map (OpenStreetMap)
/// Ce fichier montre différentes fonctionnalités disponibles
class MapExamplesScreen extends StatefulWidget {
  const MapExamplesScreen({super.key});

  @override
  State<MapExamplesScreen> createState() => _MapExamplesScreenState();
}

class _MapExamplesScreenState extends State<MapExamplesScreen> {
  final MapController _mapController = MapController();
  int _selectedExample = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemples OpenStreetMap'),
        actions: [
          PopupMenuButton<int>(
            initialValue: _selectedExample,
            onSelected: (value) {
              setState(() => _selectedExample = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 0, child: Text('Carte standard')),
              const PopupMenuItem(value: 1, child: Text('Carte sombre')),
              const PopupMenuItem(value: 2, child: Text('Carte claire')),
              const PopupMenuItem(value: 3, child: Text('Topographique')),
              const PopupMenuItem(value: 4, child: Text('Avec cercles')),
              const PopupMenuItem(value: 5, child: Text('Avec polygones')),
            ],
          ),
        ],
      ),
      body: _buildExample(_selectedExample),
    );
  }

  Widget _buildExample(int index) {
    switch (index) {
      case 1:
        return _buildDarkMap();
      case 2:
        return _buildLightMap();
      case 3:
        return _buildTopoMap();
      case 4:
        return _buildCirclesMap();
      case 5:
        return _buildPolygonsMap();
      default:
        return _buildStandardMap();
    }
  }

  // 1️⃣ Carte standard OpenStreetMap
  Widget _buildStandardMap() {
    return FlutterMap(
      mapController: _mapController,
      options: const MapOptions(
        initialCenter: LatLng(36.7538, 3.0588), // Alger
        initialZoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.alerts',
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 50,
              height: 50,
              point: const LatLng(36.7538, 3.0588),
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 50,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2️⃣ Carte sombre (Dark Theme)
  Widget _buildDarkMap() {
    return FlutterMap(
      mapController: _mapController,
      options: const MapOptions(
        initialCenter: LatLng(36.7538, 3.0588),
        initialZoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.alerts',
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 50,
              height: 50,
              point: const LatLng(36.7538, 3.0588),
              child: const Icon(
                Icons.location_on,
                color: Colors.cyan,
                size: 50,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 3️⃣ Carte claire (Light Theme)
  Widget _buildLightMap() {
    return FlutterMap(
      mapController: _mapController,
      options: const MapOptions(
        initialCenter: LatLng(36.7538, 3.0588),
        initialZoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.alerts',
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 50,
              height: 50,
              point: const LatLng(36.7538, 3.0588),
              child: const Icon(
                Icons.location_on,
                color: Colors.deepPurple,
                size: 50,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 4️⃣ Carte topographique
  Widget _buildTopoMap() {
    return FlutterMap(
      mapController: _mapController,
      options: const MapOptions(
        initialCenter: LatLng(36.7538, 3.0588),
        initialZoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.opentopomap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.alerts',
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 50,
              height: 50,
              point: const LatLng(36.7538, 3.0588),
              child: const Icon(
                Icons.terrain,
                color: Colors.green,
                size: 50,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 5️⃣ Carte avec cercles (zones de couverture)
  Widget _buildCirclesMap() {
    return FlutterMap(
      mapController: _mapController,
      options: const MapOptions(
        initialCenter: LatLng(36.7538, 3.0588),
        initialZoom: 11,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.alerts',
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: const LatLng(36.7538, 3.0588),
              radius: 2000, // 2km de rayon
              useRadiusInMeter: true,
              color: Colors.blue.withOpacity(0.3),
              borderColor: Colors.blue,
              borderStrokeWidth: 2,
            ),
            CircleMarker(
              point: const LatLng(36.7638, 3.0488),
              radius: 1500,
              useRadiusInMeter: true,
              color: Colors.red.withOpacity(0.3),
              borderColor: Colors.red,
              borderStrokeWidth: 2,
            ),
            CircleMarker(
              point: const LatLng(36.7438, 3.0688),
              radius: 1000,
              useRadiusInMeter: true,
              color: Colors.green.withOpacity(0.3),
              borderColor: Colors.green,
              borderStrokeWidth: 2,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 40,
              height: 40,
              point: const LatLng(36.7538, 3.0588),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.location_city, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 6️⃣ Carte avec polygones (zones)
  Widget _buildPolygonsMap() {
    return FlutterMap(
      mapController: _mapController,
      options: const MapOptions(
        initialCenter: LatLng(36.7538, 3.0588),
        initialZoom: 13,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.alerts',
        ),
        PolygonLayer(
          polygons: [
            // Zone 1 - Centre-ville
            Polygon(
              points: const [
                LatLng(36.7600, 3.0500),
                LatLng(36.7600, 3.0600),
                LatLng(36.7500, 3.0600),
                LatLng(36.7500, 3.0500),
              ],
              color: Colors.green.withOpacity(0.3),
              borderColor: Colors.green,
              borderStrokeWidth: 2,
              isFilled: true,
            ),
            // Zone 2 - Quartier est
            Polygon(
              points: const [
                LatLng(36.7550, 3.0650),
                LatLng(36.7550, 3.0750),
                LatLng(36.7450, 3.0750),
                LatLng(36.7450, 3.0650),
              ],
              color: Colors.orange.withOpacity(0.3),
              borderColor: Colors.orange,
              borderStrokeWidth: 2,
              isFilled: true,
            ),
            // Zone 3 - Quartier ouest
            Polygon(
              points: const [
                LatLng(36.7550, 3.0400),
                LatLng(36.7550, 3.0500),
                LatLng(36.7450, 3.0500),
                LatLng(36.7450, 3.0400),
              ],
              color: Colors.red.withOpacity(0.3),
              borderColor: Colors.red,
              borderStrokeWidth: 2,
              isFilled: true,
            ),
          ],
        ),
      ],
    );
  }
}

// 🎨 Exemple de marqueurs personnalisés
class CustomMarkerExamples {
  // Marqueur avec badge de notification
  static Marker markerWithBadge({
    required LatLng point,
    required int count,
    required Color color,
  }) {
    return Marker(
      width: 50,
      height: 50,
      point: point,
      child: Stack(
        children: [
          Icon(Icons.location_on, color: color, size: 50),
          if (count > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Marqueur avec icône personnalisée
  static Marker markerWithCustomIcon({
    required LatLng point,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Marker(
      width: 50,
      height: 50,
      point: point,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }

  // Marqueur avec animation (pulse)
  static Marker pulseMarker({
    required LatLng point,
    required Color color,
  }) {
    return Marker(
      width: 60,
      height: 60,
      point: point,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cercle extérieur (pulse)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
          ),
          // Cercle intérieur
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
          // Point central
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ],
      ),
    );
  }
}

// 🗺️ Différents styles de tuiles disponibles
class TileProviders {
  // Standard OpenStreetMap
  static const String openStreetMap = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  // CartoDB Positron (clair)
  static const String cartoDBPositron = 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';

  // CartoDB Dark Matter (sombre)
  static const String cartoDBDarkMatter = 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';

  // OpenTopoMap (topographique)
  static const String openTopoMap = 'https://tile.opentopomap.org/{z}/{x}/{y}.png';

  // Esri World Imagery (satellite) - peut nécessiter attribution
  static const String esriWorldImagery = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

  // Stamen Terrain
  static const String stamenTerrain = 'https://tiles.stadiamaps.com/tiles/stamen_terrain/{z}/{x}/{y}.png';

  // Stamen Toner (noir et blanc)
  static const String stamenToner = 'https://tiles.stadiamaps.com/tiles/stamen_toner/{z}/{x}/{y}.png';
}