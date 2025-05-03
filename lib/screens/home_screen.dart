import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:voice_rec_app/screens/about_screen.dart';
import 'package:voice_rec_app/screens/recording_list_screen.dart';
import 'package:voice_rec_app/services/audio_recorder_service.dart';
import 'package:voice_rec_app/widgets/animated_press_button.dart';
import 'package:voice_rec_app/widgets/circle_outline_button.dart';
import 'package:voice_rec_app/widgets/record_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final recorderService = AudioRecorderService();
  bool isRecording = false;
  bool isPaused = false;
  String durationText = '00:00';
  Timer? _timer;
  int _seconds = 0;

  late final RecorderController _recorderController;

  @override
  void initState() {
    super.initState();
    _recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }
String formatDurationWithMilliseconds(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;
  final milliseconds = (duration.inMilliseconds % 1000);
  return '${hours.toString().padLeft(2, '0')}:'
         '${minutes.toString().padLeft(2, '0')}:'
         '${seconds.toString().padLeft(2, '0')}.'
         '${milliseconds.toString().padLeft(3, '0')}';
}

  @override
  void dispose() {
    recorderService.dispose();
    _recorderController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startRecording() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) return;

    await recorderService.startRecording();
    await _recorderController.record();

    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        final minutes = _seconds ~/ 60;
        final seconds = _seconds % 60;
        durationText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      });
    });

    setState(() {
      isRecording = true;
      isPaused = false;
    });
  }

  Future<void> _pauseRecording() async {
    await recorderService.pauseRecording(); // You must implement this in your service using pauseRecorder()
    await _recorderController.pause();
    _timer?.cancel();
    setState(() {
      isPaused = true;
    });
  }

  Future<void> _resumeRecording() async {
    await recorderService.resumeRecording(); // You must implement this in your service using resumeRecorder()
    await _recorderController.record();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        final minutes = _seconds ~/ 60;
        final seconds = _seconds % 60;
        durationText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      });
    });
    setState(() {
      isPaused = false;
    });
  }

  Future<void> _stopRecording() async {
    await recorderService.stopRecording();
    await _recorderController.stop();

    _timer?.cancel();
    setState(() {
      isRecording = false;
      isPaused = false;
      durationText = '00:00';
    });
  }
  Future<void> _cancelRecording() async {
  await recorderService.cancelRecording();
  await _recorderController.stop();
  _timer?.cancel();
  setState(() {
    isRecording = false;
    isPaused = false;
    _seconds = 0;
    durationText = '00:00';
  });
}


  @override
Widget build(BuildContext context) {
  final accent = Colors.red; // Or Color(0xFFFF1744) for a modern red

  return Scaffold(
    backgroundColor: const Color(0xFF101820),
    body: SafeArea(
      child: Column(
        children: [
          // --- TOP BAR ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                icon: Icon(Icons.settings, color: accent, size: 32),
                onPressed: () {
                Navigator.push(
                 context,
                 MaterialPageRoute(builder: (_) => const AboutScreen()),
    );
  },
),
                Text(
                  isRecording ? "Recording..." : "Ready",
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    letterSpacing: 1.1,
                  ),
                ),
                // List/Menu Button now in top right
                IconButton(
                  icon: Icon(Icons.menu, color: accent, size: 32),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const RecordingListScreen(),
                    ));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // --- TIMER ---
          Column(
            children: [
              Text(
                durationText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // --- FULL-WIDTH WAVEFORM ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: AudioWaveforms(
              enableGesture: false,
              size: Size(MediaQuery.of(context).size.width, 100),
              recorderController: _recorderController,
              waveStyle: WaveStyle(
                waveColor: accent,
                extendWaveform: true,
                showMiddleLine: false,
                scaleFactor: 180,
                spacing: 6,
              ),
            ),
          ),
          const Spacer(),
          // --- ACTION BUTTONS WITH TEXT LABELS ---
          Padding(
  padding: const EdgeInsets.only(bottom: 36, left: 32, right: 32, top: 8),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Save Button (bottom left)
      Column(
        children: [
          AnimatedPressButton(
            onTap: isRecording ? _stopRecording : null,
            child: CircleOutlineButton(
              icon: Icons.save,
              accent: accent,
              onTap: null, // onTap handled by AnimatedPressButton
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Save",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
      // Record/Pause/Resume Button (center)
      Column(
        children: [
          AnimatedPressButton(
            onTap: () {
              if (!isRecording) {
                _startRecording();
              } else if (isPaused) {
                _resumeRecording();
              } else {
                _pauseRecording();
              }
            },
            child: CircleOutlineButton(
              icon: !isRecording
                  ? Icons.fiber_manual_record
                  : (isPaused ? Icons.play_arrow : Icons.pause),
              accent: accent,
              fill: true,
              onTap: null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            !isRecording ? "Record" : (isPaused ? "Pause" : "Pause"),
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
      // Cancel Button (bottom right)
      Column(
        children: [
          AnimatedPressButton(
            onTap: isRecording ? _cancelRecording : null,
            child: CircleOutlineButton(
              icon: Icons.cancel,
              accent: accent,
              onTap: null,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Cancel",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    ],
  ),
),

        ],
      ),
    ),
  );
}
}
