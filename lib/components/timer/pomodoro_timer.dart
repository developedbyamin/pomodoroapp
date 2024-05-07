import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/session_repository.dart';
import '../../screens/settings/settings_controller.dart';
import '../../utils/constants/sizes.dart';

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> with SingleTickerProviderStateMixin {

  FocusSessionRepository repository = FocusSessionRepository();

  final TextEditingController changeMinutes = TextEditingController();
  bool _isRunning = false;
  int _minutes = 25;
  late int _seconds;
  late Timer _timer;
  final player = AudioPlayer();
  late AnimationController _animationController;
  late Animation<double> _borderWidthAnimation;

  @override
  void initState() {
    super.initState();
    _seconds = _minutes * 60;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _borderWidthAnimation = Tween<double>(
      begin: 1.0,
      end: 5.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
          } else {
            _timer.cancel();
            _isRunning = false;
            _playSound();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Provider.of<SettingsController>(context, listen: false).selectedGradient[2],
                  title: const Text('Timer Ended', style: TextStyle(color: Colors.white),),
                  content: const Text('Press OK to close this menu', style: TextStyle(color: Colors.white),),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        player.stop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK', style: TextStyle(color: Colors.white),),
                    ),
                  ],
                );
              },
            ).then((value) {
              if (!_isRunning) {
                player.stop();
              }
            });
          }
        });
      });
      _animationController.forward();
    }
  }

  void _pauseTimer() {
    if (_isRunning) {
      _timer.cancel();
      _isRunning = false;
      _animationController.reverse();
    }
  }

  void _resetTimer() async {
    // Calculate focused seconds by subtracting remaining seconds from initial duration
    int focusedSeconds = _minutes * 60 - _seconds;

    // Save the focus session record
    await repository.saveFocusSession(focusedSeconds, DateTime.now());
    // Reset the timer
    _timer.cancel();
    _isRunning = false;
    _animationController.reset();
    setState(() {
      _seconds = _minutes * 60;
    });
  }



  Future<void> _playSound() async {
    player.setReleaseMode(ReleaseMode.stop);
    await player.setSource(AssetSource('alarm.mp3'));
    await player.resume();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsStr = remainingSeconds < 10 ? '0$remainingSeconds' : '$remainingSeconds';
    return '$minutesStr:$secondsStr';
  }

  void _changeMinutes(BuildContext context) {
    _animationController.reverse();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Provider.of<SettingsController>(context, listen: false).selectedGradient[2],
          title: Text(
            'Set Minutes',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.white),
          ),
          content: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Provider.of<SettingsController>(context, listen: false).selectedGradient[1],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              hintText: 'Enter minutes',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            controller: changeMinutes,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _minutes = int.tryParse(changeMinutes.text) ?? _minutes;
                  changeMinutes.text = '';
                  _seconds = _minutes * 60;
                  if (_isRunning) {
                    _isRunning = false;
                    _timer.cancel();
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        AnimatedBuilder(
          animation: _borderWidthAnimation,
          builder: (context, child) {
            return Container(
              height: 100,
              width: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: _borderWidthAnimation.value),
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.all(PomodoroAppSizes.spaceBtwItems),
              child: GestureDetector(
                onTap: () => _changeMinutes(context),
                child: Center(
                  child: Text(
                    _formatTime(_seconds),
                    style: textTheme.displayMedium!.copyWith(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: PomodoroAppSizes.spaceBtwItems),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (!_isRunning) {
                          _startTimer();
                        } else {
                          _pauseTimer();
                        }
                      });
                    },
                    icon: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: PomodoroAppSizes.spaceBtwItems,),
                Text(_isRunning ? 'Pause' : 'Start', style: textTheme.bodySmall!.copyWith(color: Colors.white),),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _resetTimer,
                    icon: const Icon(
                      Icons.fiber_manual_record,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: PomodoroAppSizes.spaceBtwItems,),
                Text('Save/Reset', style: textTheme.bodySmall!.copyWith(color: Colors.white),),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
