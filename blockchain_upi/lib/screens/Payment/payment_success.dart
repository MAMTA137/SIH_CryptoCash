import 'package:audioplayers/audioplayers.dart';
import 'package:blockchain_upi/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Play the success sound and delay the Navigator.pop() for 4 seconds
    _playSuccessSound();
  }

  void _playSuccessSound() async {
    // Play the sound from the assets
    await _audioPlayer.play(AssetSource('success.mp3'));

    // Wait for 4 seconds after playing the sound, then pop the screen
    await Future.delayed(const Duration(seconds: 4));

    // Pop the screen after 4 seconds
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1,
      body: Center(
        child: LottieBuilder.asset(
          "assets/new.json", // Make sure this path is correct
          repeat: false,
          height: 500,
          width: 500,
        ),
      ),
    );
  }
}
