import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeController extends GetxController {
  late YoutubePlayerController youtubePlayerController;
  var isPlayerReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    youtubePlayerController = YoutubePlayerController(
      initialVideoId:
          'https://youtu.be/BoqapEBY29E?si=RGeIdY0I567xdgDU', // Replace with your YouTube video ID
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    )..addListener(() {
        if (youtubePlayerController.value.isReady) {
          isPlayerReady.value = true;
        }
      });
  }

  void playVideo() {
    youtubePlayerController.play();
  }

  void pauseVideo() {
    youtubePlayerController.pause();
  }

  @override
  void onClose() {
    youtubePlayerController.dispose();
    super.onClose();
  }
}
