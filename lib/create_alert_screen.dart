import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'models.dart';
import 'database_helper.dart';
import 'utils.dart';
import 'context_extensions.dart';

class CreateAlertScreen extends StatefulWidget {
  final User user;

  const CreateAlertScreen({super.key, required this.user});

  @override
  State<CreateAlertScreen> createState() => _CreateAlertScreenState();
}

class _CreateAlertScreenState extends State<CreateAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String? _selectedType;
  String? _selectedCategory;
  List<XFile> _selectedImages = [];
  List<File> _selectedFiles = [];
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  bool _isSubmitting = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError(context.l10n.errorLocationPermission);
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError(context.l10n.errorLocationPermission);
        setState(() => _isLoadingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      if (mounted) {
        context.showSuccess('✅ ' + context.l10n.success);
      }
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      _showError('Error: $e');
    }
  }

  Future<void> _pickImages() async {
    try {
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.takePhoto),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: Text(context.l10n.takePhoto),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: Text(context.l10n.chooseFromGallery),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      if (source == ImageSource.gallery) {
        final List<XFile> images = await _picker.pickMultiImage();
        if (images.isNotEmpty) {
          setState(() {
            _selectedImages.addAll(images);
          });
        }
      } else {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          setState(() {
            _selectedImages.add(image);
          });
        }
      }

      if (_selectedImages.length > 5) {
        _selectedImages = _selectedImages.sublist(0, 5);
        _showError('Max 5 photos');
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        setState(() {
          _selectedFiles.addAll(result.paths.map((path) => File(path!)).toList());
        });
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Future<String> _saveImage(XFile imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
      final savePath = path.join(appDir.path, 'alert_photos', fileName);

      final directory = Directory(path.dirname(savePath));
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      await File(imageFile.path).copy(savePath);
      return savePath;
    } catch (e) {
      throw Exception('Error saving image: $e');
    }
  }

  Future<String> _saveFile(File file) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      final savePath = path.join(appDir.path, 'alert_files', fileName);

      final directory = Directory(path.dirname(savePath));
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      await file.copy(savePath);
      return savePath;
    } catch (e) {
      throw Exception('Error saving file: $e');
    }
  }

  Future<void> _submitAlert() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedType == null) {
      _showError(context.l10n.errorNoType);
      return;
    }

    if (_currentPosition == null) {
      _showError(context.l10n.errorNoLocation);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final alert = Alert(
        userId: widget.user.id!,
        type: _selectedType!,
        description: _descriptionController.text.trim(),
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        accuracy: _currentPosition!.accuracy,
      );

      final alertId = await DatabaseHelper.instance.createAlert(alert);

      // Save Photos
      for (var imageFile in _selectedImages) {
        final savedPath = await _saveImage(imageFile);
        final photo = AlertPhoto(alertId: alertId, photoPath: savedPath);
        await DatabaseHelper.instance.createAlertPhoto(photo);
      }

      // Save Files
      for (var file in _selectedFiles) {
        final savedPath = await _saveFile(file);
        final alertFile = AlertFile(
          alertId: alertId,
          filePath: savedPath,
          fileName: path.basename(file.path),
        );
        await DatabaseHelper.instance.createAlertFile(alertFile);
      }

      if (mounted) {
        context.showSuccess(context.l10n.successAlertCreated);
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    context.showError(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.createAlert),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.alertType,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: context.l10n.filter,
                        prefixIcon: const Icon(Icons.category),
                      ),
                      value: _selectedCategory,
                      items: Utils.getAlertTypesWithCategories(context.isArabic)
                          .keys
                          .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                          _selectedType = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_selectedCategory != null)
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: context.l10n.alertType,
                          prefixIcon: const Icon(Icons.label),
                        ),
                        value: _selectedType,
                        items: Utils.getAlertTypesWithCategories(context.isArabic)[_selectedCategory!]!
                            .map((type) => DropdownMenuItem(
                          value: type['name'],
                          child: Text(type['name']!),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedType = value);
                        },
                        validator: (value) {
                          if (value == null) return context.l10n.errorNoType;
                          return null;
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.alertDescription,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: context.l10n.describeAlert,
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.l10n.errorNoDescription;
                        }
                        if (value.trim().length < 10) {
                          return context.l10n.fieldTooShort;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Photos Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${context.l10n.alertPhotos} (${_selectedImages.length}/5)',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        if (_selectedImages.length < 5)
                          TextButton.icon(
                            onPressed: _pickImages,
                            icon: const Icon(Icons.add_photo_alternate),
                            label: Text(context.l10n.addPhotos),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_selectedImages.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.image_outlined, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text(context.l10n.noData, style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_selectedImages[index].path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                left: 4,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Files Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          context.l10n.alertFiles,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: _pickFiles,
                          icon: const Icon(Icons.attach_file),
                          label: Text(context.l10n.addFiles),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_selectedFiles.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.file_present, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text(context.l10n.noData, style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _selectedFiles.length,
                        itemBuilder: (context, index) {
                          final file = _selectedFiles[index];
                          return ListTile(
                            leading: const Icon(Icons.insert_drive_file),
                            title: Text(path.basename(file.path)),
                            subtitle: Text('${(file.lengthSync() / 1024).toStringAsFixed(2)} KB'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeFile(index),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.alertLocation,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_isLoadingLocation)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 12),
                              Text('...'),
                            ],
                          ),
                        ),
                      )
                    else if (_currentPosition == null)
                      Column(
                        children: [
                          Icon(Icons.location_off, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(context.l10n.errorNoLocation, style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: _getCurrentLocation,
                            icon: const Icon(Icons.my_location),
                            label: Text(context.l10n.myLocation),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(context.l10n.success,
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('${context.l10n.locationAccuracy}: ${Utils.formatAccuracy(_currentPosition!.accuracy, context.l10n)}',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color(Utils.getAccuracyColor(_currentPosition!.accuracy)))),
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: _getCurrentLocation,
                            icon: const Icon(Icons.refresh),
                            label: Text(context.l10n.refresh),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitAlert,
                child: _isSubmitting
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text(
                  context.l10n.submit,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
