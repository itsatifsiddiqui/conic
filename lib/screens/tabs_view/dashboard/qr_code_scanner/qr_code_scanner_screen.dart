import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../providers/firestore_provider.dart';
import '../../../../res/platform_dialogue.dart';
import '../../../../res/res.dart';
import '../my_connections/firend_detail.dart';

class QrCodeScannerScreen extends StatefulHookWidget {
  const QrCodeScannerScreen({Key? key}) : super(key: key);

  @override
  _QrCodeScannerScreenState createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  late QRViewController controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    return LoadingOverlay(
      isLoading: isLoading.value,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: 'Scan QR Code'.text.xl.color(context.adaptive).make(),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: 1.seconds,
                    opacity: result == null ? 0 : 1,
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () async {
                          final uri = Uri.parse(result!.code);
                          final dynamicLink =
                              await FirebaseDynamicLinks.instance.getDynamicLink(uri);
                          if (dynamicLink == null) {
                            result = null;
                            setState(() {});
                            return;
                          }
                          try {
                            isLoading.value = true;
                            final linkUri = dynamicLink.link;
                            final parameters = linkUri.queryParameters;
                            final userId = parameters['userid']!;
                            final userData =
                                await context.read(firestoreProvider).getUserDataById(userId);
                            // ignore: unawaited_futures
                            await Get.to<void>(
                              () => FriendDetailScreen(friend: userData, fromFollowing: false),
                            );
                            isLoading.value = false;
                          } catch (e) {
                            isLoading.value = false;
                            await showPlatformDialogue(title: e.toString());
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: context.primaryColor,
                            borderRadius: BorderRadius.circular(kBorderRadius),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.open_in_new_rounded,
                                size: 16,
                              ),
                              8.widthBox,
                              'Conic'.text.make(),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 16,
                              ),
                            ],
                          ),
                        ).pOnly(bottom: 190),
                      ),
                    ),
                  )
                ],
              ).expand(),
            ],
          ),
        ),
        // body: Column(
        //   children: [
        //     Expanded(
        //       child: QRView(
        //         key: qrKey,
        //         onQRViewCreated: _onQRViewCreated,
        //         overlay: QrScannerOverlayShape(
        //           borderRadius: 10,
        //           borderLength: 30,
        //           borderWidth: 10,
        //         ),
        //       ),
        //     ),
        //     // Expanded(
        //     //   flex: 1,
        //     //   child: Center(
        //     //     child: (result != null)
        //     //         ? Text('Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
        //     //         : const Text('Scan a code'),
        //     //   ),
        //     // )
        //   ],
        // ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
