import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:conic/models/linked_media.dart';
import 'package:conic/providers/firestore_provider.dart';
import 'package:conic/res/platform_dialogue.dart';

import '../../../res/res.dart';

class ImageViewer extends HookWidget {
  const ImageViewer({
    Key? key,
    required this.media,
  }) : super(key: key);
  final LinkedMedia media;

  @override
  Widget build(BuildContext context) {
    //Disable hero effect from this screen.
    //Having hero on pop cause picture to animate as zoom out.
    final heroEnabled = useState(true);
    useEffect(() {
      Future<void>.delayed(250.milliseconds, () => heroEnabled.value = false);
      return null;
    });
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
              await context.read(firestoreProvider).deleteMedia(media);
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: InteractiveViewer(
        alignPanAxis: true,
        child: HeroMode(
          enabled: heroEnabled.value,
          child: Hero(
            tag: media.url,
            child: CachedNetworkImage(
              imageUrl: media.url,
              height: double.infinity,
              width: double.infinity,
              placeholder: kImagePlaceHodler,
              // fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
