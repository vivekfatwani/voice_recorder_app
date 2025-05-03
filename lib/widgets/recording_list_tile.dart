import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:voice_rec_app/models/recording.dart';

class RecordingListTile extends StatefulWidget {
  final Recording recording;
  final VoidCallback onDelete;
  final VoidCallback onRename;

  const RecordingListTile({
    super.key,
    required this.recording,
    required this.onDelete,
    required this.onRename,
  });

  @override
  State<RecordingListTile> createState() => _RecordingListTileState();
}

class _RecordingListTileState extends State<RecordingListTile> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player.openPlayer();
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (isPlaying) {
      await _player.stopPlayer();
    } else {
      await _player.startPlayer(
        fromURI: widget.recording.filePath,
        codec: Codec.aacADTS,
        whenFinished: () {
          setState(() => isPlaying = false);
        },
      );
    }
    setState(() => isPlaying = !isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF8F9FB), // Soft, modern card color
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: isPlaying ? Colors.redAccent : Colors.deepPurpleAccent.withOpacity(0.13),
            child: Icon(
              isPlaying ? Icons.stop_circle : Icons.play_arrow,
              color: isPlaying ? Colors.white : Colors.deepPurple,
              size: 28,
            ),
          ),
          title: Text(
            widget.recording.name.replaceAll('.aac', ''),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: Color(0xFF181829),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${widget.recording.dateTime} • ${widget.recording.duration}',
            style: const TextStyle(
              color: Color(0xFF5F6277),
              fontSize: 14,
            ),
          ),
          trailing: PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.grey[700], size: 26),
            onSelected: (value) {
              if (value == 'rename') widget.onRename();
              if (value == 'delete') widget.onDelete();
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'rename',
                child: Text("Rename"),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text("Delete"),
              ),
            ],
          ),
          onTap: _togglePlay,
        ),
      ),
    );
  }
}
