import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class AudioRecorderService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isInitialized = false;
  String? _currentFilePath; // Store the path of the current recording

  Future<void> _init() async {
    if (_isInitialized) return;
    await _recorder.openRecorder();
    _isInitialized = true;
  }

  Future<void> startRecording() async {
    await _init();
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'Recording_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.aac';
    final filePath = '${directory.path}/$fileName';
    _currentFilePath = filePath; // Save the path

    await _recorder.startRecorder(
      toFile: filePath,
      codec: Codec.aacADTS,
    );
  }

  Future<void> pauseRecording() async {
    if (!_isInitialized) return;
    await _recorder.pauseRecorder();
  }

  Future<void> resumeRecording() async {
    if (!_isInitialized) return;
    await _recorder.resumeRecorder();
  }

  Future<void> stopRecording() async {
    if (!_isInitialized) return;
    await _recorder.stopRecorder();
    _currentFilePath = null; // Reset after normal stop
  }

  /// Cancels the recording and deletes the incomplete file.
  Future<void> cancelRecording() async {
    if (!_isInitialized) return;
    await _recorder.stopRecorder();
    if (_currentFilePath != null) {
      final file = File(_currentFilePath!);
      if (await file.exists()) {
        await file.delete(); // Delete the incomplete recording
      }
      _currentFilePath = null;
    }
  }

  void dispose() {
    _recorder.closeRecorder();
    _isInitialized = false;
  }
}
