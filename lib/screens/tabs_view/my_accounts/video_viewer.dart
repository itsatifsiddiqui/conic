import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/error_widet.dart';

class VideoViewer extends StatefulWidget {
  const VideoViewer({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;

  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late Widget betterPlayer;
  @override
  void initState() {
    super.initState();
    betterPlayer = BetterPlayer.network(
      widget.url,
      betterPlayerConfiguration: BetterPlayerConfiguration(
        allowedScreenSleep: false,
        fullScreenByDefault: true,
        autoPlay: true,
        autoDetectFullscreenDeviceOrientation: true,
        fit: BoxFit.contain,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        deviceOrientationsOnFullScreen: DeviceOrientation.values,
        errorBuilder: (_, __) => StreamErrorWidget(error: _.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [betterPlayer],
      ),
    );
  }
}
