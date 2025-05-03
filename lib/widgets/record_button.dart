import 'package:flutter/material.dart';

class RecordButton extends StatelessWidget {
  final bool isRecording;
  final bool isPaused;
  final VoidCallback onRecord;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStop;

  const RecordButton({
    super.key,
    required this.isRecording,
    required this.isPaused,
    required this.onRecord,
    required this.onPause,
    required this.onResume,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    if (!isRecording) {
      // Show the big record button
      return FloatingActionButton.large(
        onPressed: onRecord,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.mic, size: 36),
      );
    } else {
      // Show Pause/Resume and Stop buttons side by side
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'pause_resume',
            onPressed: isPaused ? onResume : onPause,
            backgroundColor: Colors.orange,
            child: Icon(
              isPaused ? Icons.play_arrow : Icons.pause,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 40),
          FloatingActionButton(
            heroTag: 'stop',
            onPressed: onStop,
            backgroundColor: Colors.red,
            child: const Icon(Icons.stop, size: 32, color: Colors.white),
          ),
        ],
      );
    }
  }
}
