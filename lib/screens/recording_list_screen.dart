import 'package:flutter/material.dart';
import 'package:voice_rec_app/models/recording.dart';
import 'package:voice_rec_app/services/file_service.dart';
import 'package:voice_rec_app/widgets/recording_list_tile.dart';

class RecordingListScreen extends StatefulWidget {
  const RecordingListScreen({super.key});

  @override
  State<RecordingListScreen> createState() => _RecordingListScreenState();
}

class _RecordingListScreenState extends State<RecordingListScreen> {
  final FileService _fileService = FileService();
  List<Recording> _recordings = [];

  @override
  void initState() {
    super.initState();
    _loadRecordings();
  }

  Future<void> _loadRecordings() async {
    final files = await _fileService.getAllRecordings();
    setState(() {
      _recordings = files;
    });
  }

  Future<void> _onRename(Recording rec) async {
  final controller = TextEditingController(text: rec.name.replaceAll('.aac', ''));
  final result = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFFFFEBEE), // Light red background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: const Text(
        "Rename Recording",
        style: TextStyle(
          color: Color(0xFFD32F2F), // Bold red title
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "New name",
          labelStyle: TextStyle(color: Color(0xFFD32F2F), fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFD32F2F)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFD32F2F), width: 2),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Color(0xFFD32F2F), // Red text
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, controller.text),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFFD32F2F), // Red button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            "Rename",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      ],
    ),
  );

  if (result != null && result.trim().isNotEmpty) {
    await _fileService.renameRecording(rec.filePath, result.trim());
    await _loadRecordings();
  }
}


  Future<void> _onDelete(Recording rec) async {
    await _fileService.deleteRecording(rec.filePath);
    await _loadRecordings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Recordings")),
      body: _recordings.isEmpty
          ? const Center(child: Text("No recordings found"))
          : ListView.builder(
              itemCount: _recordings.length,
              itemBuilder: (ctx, index) {
                final rec = _recordings[index];
                return RecordingListTile(
                  recording: rec,
                  onDelete: () => _onDelete(rec),
                  onRename: () => _onRename(rec),
                );
              },
            ),
    );
  }
}
