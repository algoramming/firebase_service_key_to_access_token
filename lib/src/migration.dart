import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'ksnackbar.dart';
import 'service.dart';

class FcmMigrationScreen extends StatefulWidget {
  const FcmMigrationScreen({super.key});

  @override
  State<FcmMigrationScreen> createState() => _FcmMigrationScreenState();
}

class _FcmMigrationScreenState extends State<FcmMigrationScreen> {
  DropzoneViewController? _dropzoneController;
  PlatformFile? _pickedFile;
  bool _isHovering = false; // NEW: Tracks hover state

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drag and Drop Upload Zone
        _buildDropZone(),

        if (_pickedFile != null) ...[
          const SizedBox(height: 10),
          _buildFileDetails(),
        ],

        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: _pickedFile == null ? null : _processFile,
            child: const Text('👉 Get Access Token'),
          ),
        ),
      ],
    );
  }

  Widget _buildDropZone() {
    return GestureDetector(
      onTap: () async {
        if (_dropzoneController == null) return;

        final files =
            await _dropzoneController!
                .pickFiles(); // Allow manual file selection
        if (files.isNotEmpty) {
          final bytes = await _dropzoneController!.getFileData(files.first);
          _handleFile(files.first.name, bytes);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 150,
        decoration: BoxDecoration(
          color:
              _isHovering
                  ? Colors.blue[100]
                  : Colors.grey[200], // CHANGED: Background color on hover
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blueAccent, width: 2),
        ),
        child: Stack(
          children: [
            DropzoneView(
              onCreated: (controller) => _dropzoneController = controller,
              onDropFile: (file) async {
                final bytes = await _dropzoneController!.getFileData(file);
                _handleFile(file.name, bytes);
              },
              onDropFiles: (files) async {
                if (files == null || files.isEmpty) return;
                final bytes = await _dropzoneController!.getFileData(
                  files.first,
                );
                _handleFile(files.first.name, bytes);
              },
              onDropInvalid:
                  (_) => KSnackbar.show(
                    context,
                    'Invalid file type. Please upload a JSON file.',
                    isError: true,
                  ),
              onHover:
                  () => setState(
                    () => _isHovering = true,
                  ), // CHANGED: Set hover state
              onLeave:
                  () => setState(
                    () => _isHovering = false,
                  ), // CHANGED: Reset hover state
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, size: 50, color: Colors.blueAccent),
                  const SizedBox(height: 10),
                  const Text(
                    'Drag & Drop JSON file here\nor Click to Upload',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('✅ File Selected: ${_pickedFile!.name}'),
        Text('📦 Size: ${(_pickedFile!.size / 1024).toStringAsFixed(2)} KB'),
      ],
    );
  }

  void _handleFile(String fileName, Uint8List bytes) {
    setState(() {
      _pickedFile = PlatformFile(
        name: fileName,
        size: bytes.length,
        bytes: bytes,
      );
    });
  }

  void _processFile() async {
    if (_pickedFile == null) return;
    EasyLoading.show();

    try {
      final jsonContent = utf8.decode(_pickedFile!.bytes!);
      final jsonData = jsonDecode(jsonContent) as Map<String, dynamic>;

      final accessToken = await GoogleServerService().getAccessToken(jsonData);

      debugPrint(accessToken);
      EasyLoading.dismiss();
      _showAccessTokenDialog(accessToken); // Show dialog after fetching token
    } catch (e) {
      EasyLoading.showError('Error processing file');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void _showAccessTokenDialog(String accessToken) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text('🔑 Access Token'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    accessToken,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              // Copy to Clipboard Button
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: accessToken));
                  EasyLoading.showToast(
                    'Copied to Clipboard',
                    toastPosition: EasyLoadingToastPosition.bottom,
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy'),
              ),

              // Close Button (Clears File)
              TextButton.icon(
                onPressed: () {
                  setState(() => _pickedFile = null); // Reset File
                  Navigator.pop(context); // Close Dialog
                },
                icon: const Icon(Icons.close),
                label: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
