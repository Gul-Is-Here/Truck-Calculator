import 'package:dispatched_calculator_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: '03FsQQUsj7I',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        isLive: false,
      ),
    )..addListener(_youtubePlayerListener);
  }

  void _youtubePlayerListener() {
    if (_controller.value.hasError) {
      debugPrint('YouTube Player Error: ${_controller.value.errorCode}');
    } else {
      debugPrint('YouTube Player State: ${_controller.value.playerState}');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColor().secondaryAppColor,
        progressColors: const ProgressBarColors(
          playedColor: Colors.green,
          handleColor: Colors.redAccent,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tutorial'),
          ),
          body: Center(child: player),
        );
      },
    );
  }
}
