import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:conic/providers/firestore_provider.dart';
import 'package:conic/res/platform_dialogue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:conic/models/linked_media.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../res/res.dart';
import '../../../widgets/error_widet.dart';

class VideoViewer extends StatefulWidget {
  const VideoViewer({
    Key? key,
    required this.media,
  }) : super(key: key);
  final LinkedMedia media;

  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late Widget betterPlayer;
  @override
  void initState() {
    super.initState();
    betterPlayer = BetterPlayer.network(
      widget.media.url,
      betterPlayerConfiguration: BetterPlayerConfiguration(
        allowedScreenSleep: false,
        fullScreenByDefault: Platform.isAndroid,
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
        actions: [
          IconButton(
            onPressed: () async {
              final result = await showPlatformDialogue(
                title: "Delete",
                content: Text('Are you sure you want to delete?'),
                action1OnTap: true,
                action2OnTap: false,
                action1Text: "Delete",
                action2Text: "No",
              );
              if (result != true) return;
              await context.read(firestoreProvider).deleteMedia(widget.media);
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            betterPlayer.expand(),
          ],
        ),
      ),
    );
  }
}
