import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class WaveformDisplay extends StatelessWidget {
  final RecorderController recorderController;

  const WaveformDisplay({
    Key? key,
    required this.recorderController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AudioWaveforms(
        enableGesture: false,
        size: Size(MediaQuery.of(context).size.width * 0.9, 120), // Large and wide
        recorderController: recorderController,
        waveStyle: const WaveStyle(
          waveColor: Colors.white,
          extendWaveform: true,
          showMiddleLine: false,
          scaleFactor: 150
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.only(bottom: 24), // Space above button
      ),
    );
  }
}
