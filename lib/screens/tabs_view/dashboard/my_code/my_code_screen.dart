import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../providers/app_user_provider.dart';
import '../../../../res/platform_dialogue.dart';
import '../../../../res/res.dart';
import '../../../../widgets/primary_button.dart';

class MyCodeScreen extends HookWidget {
  const MyCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = useProvider(appUserProvider.select((value) => value!.image));
    final link = useProvider(appUserProvider.select((value) => value!.link))!;

    late ScreenshotController screenshotController;
    useEffect(() {
      screenshotController = ScreenshotController();
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: 'My QR Code'.text.xl.color(context.adaptive).make(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              try {
                final imageBytes = await screenshotController.capture();
                if (imageBytes == null) return;
                final result = await ImageGallerySaver.saveImage(imageBytes) as Object?;
                if (result is Map && (result['isSuccess'] as bool)) {
                  await showPlatformDialogue(
                    title: 'QR Code Saved',
                    content: const Text('Your QR code has been saved to your photos'),
                  );
                }
              } catch (e) {
                debugPrint(e.toString());
              }
            },
            child: Column(
              children: [
                'Tap to save'.text.bold.makeCentered().py12(),
                12.heightBox,
                Screenshot<Object>(
                  key: const ValueKey('PrettyQr'),
                  controller: screenshotController,
                  child: PrettyQr(
                    elementColor: context.adaptive,
                    image: image == null ? null : CachedNetworkImageProvider(image),
                    data: link,
                    roundEdges: true,
                    size: context.height * 0.25,
                  ).centered(),
                ),
                12.heightBox,
              ],
            ),
          ),
          12.heightBox,
          link.text.bold.make().p16().mdClick(() {
            VxToast.show(
              context,
              msg: 'Profile link copied',
              textColor: context.canvasColor,
            );
          }).make(),
          24.heightBox,
          PrimaryButton(
            width: 0.5.sw,
            onTap: () {
              Share.share(link);
            },
            text: 'Share profile link',
          ),
          24.heightBox,
        ],
      ),
    );
  }
}
