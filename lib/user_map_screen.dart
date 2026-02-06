import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'models.dart';
import 'database_helper.dart';
import 'alert_detail_screen.dart';
import 'utils.dart';
import 'context_extensions.dart';

class UserMapScreen extends StatefulWidget {
  final User user;

  const UserMapScreen({super.key, required this.user});

  @override
  State<UserMapScreen> createState() => _UserMapScreenState();
}

class _UserMapScreenState extends State<UserMapScreen> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  List<AlertWithDetails> _alerts = [];
  bool _isLoading = true;
  String? _filterStatus;

  Position? _currentPosition;
  bool _isLoadingPosition = true;
  StreamSubscription<Position>? _positionStream;
  bool _followUserLocation = true;

  static const LatLng _initialCenter = LatLng(36.7538, 3.0588);
  static const double _initialZoom = 11.0;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _loadAlerts();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    setState(() => _isLoadingPosition = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          context.showError(context.isArabic ? '⚠️ خدمة الموقع غير مفعلة' : '⚠️ Location services are disabled');
        }
        setState(() => _isLoadingPosition = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            context.showError(context.l10n.errorLocationPermission);
          }
          setState(() => _isLoadingPosition = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          context.showError(context.isArabic ? '⚠️ إذن الموقع مرفوض نهائياً. يرجى تفعيله من الإعدادات' : '⚠️ Location permission denied forever');
        }
        setState(() => _isLoadingPosition = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _currentPosition = position;
          _isLoadingPosition = false;
        });

        _mapController.move(
          LatLng(position.latitude, position.longitude),
          15.0,
        );
      }

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        if (mounted) {
          setState(() {
            _currentPosition = position;
          });

          if (_followUserLocation) {
            _mapController.move(
              LatLng(position.latitude, position.longitude),
              _mapController.camera.zoom,
            );
          }
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingPosition = false);
        context.showError('${context.isArabic ? 'خطأ في تحديد الموقع' : 'Error locating'}: $e');
      }
    }
  }

  Future<void> _loadAlerts() async {
    setState(() => _isLoading = true);

    try {
      final alerts = await DatabaseHelper.instance.getAlertsByUserId(widget.user.id!);

      List<AlertWithDetails> alertsWithDetails = [];
      List<Marker> markers = [];

      for (var alert in alerts) {
        if (_filterStatus != null && alert.status != _filterStatus) {
          continue;
        }

        final photos = await DatabaseHelper.instance.getPhotosByAlertId(alert.id!);
        final files = await DatabaseHelper.instance.getFilesByAlertId(alert.id!);
        final messageCount = await DatabaseHelper.instance.getMessageCountByAlertId(alert.id!);

        final alertWithDetails = AlertWithDetails(
          alert: alert,
          user: widget.user,
          photos: photos,
          files: files,
          messageCount: messageCount,
        );

        alertsWithDetails.add(alertWithDetails);

        markers.add(
          Marker(
            width: 40,
            height: 40,
            point: LatLng(alert.latitude, alert.longitude),
            child: GestureDetector(
              onTap: () => _showAlertBottomSheet(alertWithDetails),
              child: Icon(
                Icons.location_on,
                size: 40,
                color: alert.statusColor,
              ),
            ),
          ),
        );
      }

      if (mounted) {
        setState(() {
          _alerts = alertsWithDetails;
          _markers = markers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        context.showError('${context.l10n.error}: $e');
      }
    }
  }

  void _centerOnCurrentPosition() {
    if (_currentPosition != null) {
      setState(() {
        _followUserLocation = true;
      });
      _mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        15.0,
      );
    } else {
      context.showError(context.isArabic ? '⚠️ الموقع الحالي غير متاح' : '⚠️ Current location unavailable');
    }
  }

  void _showAlertBottomSheet(AlertWithDetails alertWithDetails) {
    final alert = alertWithDetails.alert;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.7,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: alert.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        alert.getStatusLabel(context.l10n),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: alert.statusColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: context.colors.brand.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        Utils.getAlertTypeName(alert.type, context.isArabic),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: context.colors.brand,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  alert.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlertDetailScreen(
                            alertId: alert.id!,
                            currentUser: widget.user,
                          ),
                        ),
                      ).then((_) => _loadAlerts());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: context.colors.brand,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.l10n.view,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.filterByStatus),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FilterOption(
              label: context.l10n.all,
              value: null,
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() => _filterStatus = value);
                Navigator.pop(context);
                _loadAlerts();
              },
            ),
            _FilterOption(
              label: context.l10n.statusPending,
              value: 'pending',
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() => _filterStatus = value);
                Navigator.pop(context);
                _loadAlerts();
              },
            ),
            _FilterOption(
              label: context.l10n.statusInProgress,
              value: 'in_progress',
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() => _filterStatus = value);
                Navigator.pop(context);
                _loadAlerts();
              },
            ),
            _FilterOption(
              label: context.l10n.statusResolved,
              value: 'resolved',
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() => _filterStatus = value);
                Navigator.pop(context);
                _loadAlerts();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.alertsOnMap),
            if (_alerts.isNotEmpty)
              Text(
                '${_alerts.length} ${context.l10n.alerts}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterDialog,
              ),
              if (_filterStatus != null)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAlerts,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('...'),
          ],
        ),
      )
          : Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition != null
                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                  : _initialCenter,
              initialZoom: _currentPosition != null ? 15.0 : _initialZoom,
              minZoom: 5,
              maxZoom: 18,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  setState(() {
                    _followUserLocation = false;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.alerts',
                maxZoom: 19,
              ),
              if (_currentPosition != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      radius: _currentPosition!.accuracy,
                      useRadiusInMeter: true,
                      color: Colors.blue.withOpacity(0.1),
                      borderColor: Colors.blue.withOpacity(0.3),
                      borderStrokeWidth: 1,
                    ),
                  ],
                ),
              MarkerLayer(markers: _markers),
              if (_currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 60,
                      height: 60,
                      point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          Positioned(
            bottom: 16,
            left: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.isArabic ? 'الرموز' : 'Legend',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _LegendItem(color: Colors.blue, label: context.l10n.myLocation),
                    _LegendItem(color: Colors.orange, label: context.l10n.statusPending),
                    _LegendItem(color: Colors.blue, label: context.l10n.statusInProgress),
                    _LegendItem(color: Colors.green, label: context.l10n.statusResolved),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'currentLocation',
                  onPressed: _centerOnCurrentPosition,
                  backgroundColor: _followUserLocation ? Colors.blue : Colors.white,
                  foregroundColor: _followUserLocation ? Colors.white : Colors.blue,
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final String? value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const _FilterOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      leading: Radio<String?>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
      onTap: () => onChanged(value),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
