import 'package:flutter/material.dart';

class AudioSeekBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;

  const AudioSeekBar({
    Key? key,
    required this.position,
    required this.duration,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  }) : super(key: key);

  String _format(Duration d) {
    final min = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(_format(position), style: const TextStyle(fontSize: 12, color: Colors.white70)),
        Expanded(
          child: Slider(
            min: 0,
            max: duration.inMilliseconds > 0 ? duration.inMilliseconds.toDouble() : 1,
            value: position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble(),
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.white24,
            onChanged: onChanged,
            onChangeStart: onChangeStart,
            onChangeEnd: onChangeEnd,
          ),
        ),
        Text(_format(duration), style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }
}
