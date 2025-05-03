import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_rec_app/models/recording.dart';
import 'package:just_audio/just_audio.dart';

class FileService {
  Future<List<Recording>> getAllRecordings() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync();

    List<Recording> recordings = [];

    for (var file in files) {
      if (file.path.endsWith('.aac')) {
        final stat = await File(file.path).stat();
        final name = file.uri.pathSegments.last;
        final date = DateFormat('yyyy-MM-dd – kk:mm').format(stat.modified);
        final duration = await _getAudioDuration(file.path);

        recordings.add(Recording(
          filePath: file.path,
          name: name,
          dateTime: date,
          duration: duration,
        ));
      }
    }

    recordings.sort((a, b) {
  // Parse the date string back to DateTime for proper sorting
  final format = DateFormat('yyyy-MM-dd – kk:mm');
  final dateA = format.parse(a.dateTime);
  final dateB = format.parse(b.dateTime);
  return dateB.compareTo(dateA); // Latest first
});

    return recordings;
  }

  Future<void> deleteRecording(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> renameRecording(String oldPath, String newName) async {
    final oldFile = File(oldPath);
    if (!await oldFile.exists()) return;

    final newPath = oldFile.parent.path + Platform.pathSeparator + '$newName.aac';
    await oldFile.rename(newPath);
  }

  Future<String> _getAudioDuration(String path) async {
    final player = AudioPlayer();
    try {
      await player.setFilePath(path);
      final duration = player.duration ?? Duration.zero;
      return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    } catch (e) {
      return "00:00";
    } finally {
      await player.dispose();
    }
  }
}
