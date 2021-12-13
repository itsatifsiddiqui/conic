import 'dart:io';
import 'dart:typed_data';

import 'package:conic/providers/app_user_provider.dart';
import 'package:conic/res/platform_dialogue.dart';
import 'package:conic/screens/tabs_view/my_cards/edit_card_screen.dart';
import 'package:conic/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../../res/res.dart';
import 'my_cards_tab.dart';

class ViewCardScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    late ScreenshotController screenshotController;
    useEffect(() {
      screenshotController = ScreenshotController();
    });
    final size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, watch, child) {
        final user = watch(appUserProvider);
        final card = watch(selectedCard).state;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: card!.name!.text.semiBold.color(context.adaptive).make(),
            backgroundColor: Colors.white,
            centerTitle: true,
            actions: [
              Center(
                child: GestureDetector(
                    onTap: () {
                      Get.to<void>(
                        () => EditCardScreen(
                          cardModel: card,
                        ),
                      );
                    },
                    child: 'Edit'.text.size(16).semiBold.color(AppColors.primaryColor).make()),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
          body: SizedBox(
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Screenshot<Object>(
                      key: const ValueKey('Image'),
                      controller: screenshotController,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                            width: double.infinity,
                          ),
                          Center(
                            child: Container(
                              child: Image.network(
                                card.photo!,
                                height: size.height * 0.2,
                                width: size.width * 0.34,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: double.infinity,
                            height: 20,
                          ),
                          DisplayInformationWidget(
                            subTitle: card.name ?? '',
                            title: 'Title',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DisplayInformationWidget(
                            subTitle: card.description ?? '',
                            title: 'Description',
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          'Linked Accounts'.text.size(22).semiBold.color(context.adaptive).make(),
                          const SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            spacing: 6,
                            runSpacing: 10,
                            children: user!.linkedAccounts!.map(
                              (e) {
                                if (card.accounts!.contains(e.fullLink))
                                  return Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(e.image),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                else
                                  return Container(width: 0, height: 0);
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 40),
                      child: Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              onTap: () async {
                                await screenshotController
                                    .capture(delay: const Duration(milliseconds: 10))
                                    .then((Uint8List? image) async {
                                  if (image != null) {
                                    final directory = await getApplicationDocumentsDirectory();
                                    final imagePath = await File('${directory.path}/image.png').create();
                                    await imagePath.writeAsBytes(image);

                                    /// Share Plugin
                                    await Share.shareFiles([imagePath.path]);
                                  }
                                });
                              },
                              color: card.theme == 'red'
                                  ? Colors.red
                                  : card.theme == 'green'
                                      ? Colors.green
                                      : card.theme == 'purple'
                                          ? Colors.purple
                                          : card.theme == 'pink'
                                              ? Colors.pink
                                              : card.theme == 'yehllow'
                                                  ? Colors.yellow
                                                  : card.theme == 'blue'
                                                      ? Colors.blue
                                                      : null,
                              width: size.width * 0.5,
                              text: 'Share',
                            ),
                          ),
                          20.widthBox,
                          Expanded(
                            child: PrimaryButton(
                              onTap: () async {
                                try {
                                  // await screenshotController
                                  //     .capture(delay: const Duration(milliseconds: 10))
                                  //     .then((Uint8List? image) async {
                                  //   // print(image == null);
                                  //   if (image != null) {
                                  //     // final result = await ImageGallerySaver.saveImage(image) as Object?;
                                  //     // if (result is Map && (result['isSuccess'] as bool)) {
                                  //     //   await showPlatformDialogue(
                                  //     //     title: 'Image Saved',
                                  //     //     content: const Text('Your Card Image is saved'),
                                  //     //   );
                                  //     // }
                                  //     // if (image != null) {
                                  //     final result = await ImageGallerySaver.saveImage(image.buffer.asUint8List());
                                  //     print(result);
                                  //     // _toastInfo(result.toString());
                                  //     // }
                                  //   }
                                  // });
                                  final imageBytes = await screenshotController.capture();
                                  print(imageBytes == null);
                                  if (imageBytes == null) return;
                                  final result = await ImageGallerySaver.saveImage(imageBytes) as Object?;
                                  if (result is Map && (result['isSuccess'] as bool)) {
                                    await showPlatformDialogue(
                                      title: 'Image Saved',
                                      content: const Text('Your Card Image is saved'),
                                    );
                                  }
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              },
                              color: card.theme == 'red'
                                  ? Colors.red
                                  : card.theme == 'green'
                                      ? Colors.green
                                      : card.theme == 'purple'
                                          ? Colors.purple
                                          : card.theme == 'pink'
                                              ? Colors.pink
                                              : card.theme == 'yehllow'
                                                  ? Colors.yellow
                                                  : card.theme == 'blue'
                                                      ? Colors.blue
                                                      : null,
                              width: size.width * 0.5,
                              text: 'Save',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DisplayInformationWidget extends StatelessWidget {
  const DisplayInformationWidget({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          title.text.size(22).semiBold.color(context.adaptive).make(),
          subTitle.text.size(14).color(Theme.of(context).dividerColor).make(),
        ],
      ),
    );
  }
}
