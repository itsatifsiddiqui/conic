import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../models/linked_account.dart';
import '../../../providers/app_user_provider.dart';
import '../../../providers/firebase_storage_provider.dart';
import '../../../providers/firestore_provider.dart';
import '../../../res/res.dart';
import '../../../widgets/accounts_builder.dart';
import '../../../widgets/context_action.dart';
import '../../../widgets/no_accounts_widget.dart';
import '../../../widgets/no_medias_widget.dart';
import '../../add_account/account_form_screen.dart';
import '../../add_account/add_new_account_screen.dart';
import 'add_media_sheet.dart';
import 'image_viewer.dart';
import 'pdf_viewer.dart';
import 'video_viewer.dart';

// final businessModeProvider = StateProvider<bool>((ref) => false);
final isListModeProvider = StateProvider<bool>((ref) {
  return ref.watch(appUserProvider)!.gridMode ?? true;
});

final isFocusedModeProvider = StateProvider<bool>((ref) {
  return ref.watch(appUserProvider)!.focusedMode ?? false;
});
final queryProvider = StateProvider<String>((ref) => '');

///Listen to [queryProvider] and return filtered results
final filteredAccountsStateProvider = StateProvider<List<LinkedAccount>>((ref) {
  final query = ref.watch(queryProvider).state.trim().toLowerCase();
  final allAccounts = ref.watch(appUserProvider)!.linkedAccounts ?? [];
  if (query.isEmpty) return allAccounts;
  return allAccounts.where((element) => element.name.toLowerCase().contains(query)).toList();
});

class MyAccountsTab extends HookWidget {
  const MyAccountsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: 'My Accounts'.text.semiBold.color(context.adaptive).make(),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.help_outline_rounded),
        //     onPressed: () {},
        //   )
        // ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Greetings(),
          12.heightBox,
          CupertinoSearchTextField(
            borderRadius: BorderRadius.circular(kBorderRadius),
            placeholder: 'Search account',
            prefixInsets: const EdgeInsets.all(8),
            style: TextStyle(color: context.adaptive),
            onChanged: (value) {
              context.read(queryProvider).state = value;
            },
          ),
          20.heightBox,
          const _MyAccountsTextRow(),
          24.heightBox,
          _MyAccountsBuilder(),
          24.heightBox,
          const _MyMediasRow(),
          8.heightBox,
          const _MyMediasBuilder(),
          32.heightBox,
        ],
      ).px16().scrollVertical(),
    );
  }
}

class _MyAccountsTextRow extends StatelessWidget {
  const _MyAccountsTextRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(child: 'My Accounts'.text.xl2.semiBold.tight.make()),
            'Long press for more options.'.text.sm.color(context.adaptive75).make(),
          ],
        ).expand(),
        HookBuilder(
          builder: (context) {
            final isListMode = useProvider(isListModeProvider).state;
            return IconButton(
              icon: Icon(
                isListMode ? Icons.grid_view : Icons.list_alt_sharp,
                color: context.primaryColor,
              ),
              onPressed: () {
                context.read(appUserProvider.notifier).updateListMode();
                context.read(firestoreProvider).updateUser();
              },
            );
          },
        )
      ],
    );
  }
}

class _Greetings extends HookWidget {
  const _Greetings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final name = useProvider(appUserProvider.select((value) => value?.name ?? 'Conic user'));
    final isFocusedMode = useProvider(isFocusedModeProvider).state;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(child: 'Hi, $name'.text.xl3.extraBold.tight.make()),
            // 4.heightBox,
            // 'View My Profile'.text.base.color(context.adaptive75).make(),
          ],
        ).expand(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CupertinoSwitch(
              activeColor: context.primaryColor,
              value: isFocusedMode,
              onChanged: (value) {
                context.read(appUserProvider.notifier).updateFocusedMode(value);
                context.read(firestoreProvider).updateUser();
              },
            ),
            4.heightBox,
            '${isFocusedMode ? "Disable" : "Enable"} Focused Mode'
                .text
                .xs
                .color(context.adaptive87)
                .make(),
          ],
        )
      ],
    ).py8();
  }
}

class _MyAccountsBuilder extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final accounts = useProvider(filteredAccountsStateProvider).state;
    final isFocusedMode = useProvider(isFocusedModeProvider).state;

    if (accounts.isEmpty) {
      return const NoAccountsWidget();
    }

    final filteredAccounts =
        isFocusedMode ? accounts.where((element) => element.focused).toList() : accounts;

    return LinkedAccountsBuilder(
      accounts: filteredAccounts,
      longPressEnabled: true,
    );
  }

  List<Widget> buildContextActions(BuildContext context, LinkedAccount linkedAccount) => [
        ContextActionWidget(
          onPressed: () {
            Navigator.pop(context);
          },
          trailingIcon: Icons.ios_share,
          child: const Text('Share'),
        ),
        ContextActionWidget(
          onPressed: () {
            Navigator.pop(context);
            Clipboard.setData(ClipboardData(text: linkedAccount.fullLink));
            VxToast.show(context, msg: 'Link Copied', showTime: 1000);
          },
          trailingIcon: Icons.content_copy_outlined,
          child: const Text('Copy'),
        ),
        ContextActionWidget(
          onPressed: () {
            kOpenLink(linkedAccount.fullLink!);
            Navigator.pop(context);
          },
          trailingIcon: Icons.open_in_new_outlined,
          child: const Text('Open'),
        ),
        ContextActionWidget(
          onPressed: () {
            Navigator.pop(context);
            final allAccounts = context.read(allAccountsProvider).data!.value;
            final account = allAccounts.whereName(linkedAccount.name);
            debugPrint(account.toString());
            Get.to<void>(
              () => AccountFormScreen(
                account: account,
                linkedAccount: linkedAccount,
              ),
            );
          },
          trailingIcon: Icons.edit_outlined,
          child: const Text('Edit'),
        ),
        ContextActionWidget(
          isDestructiveAction: true,
          trailingIcon: Icons.close,
          onPressed: () {
            context.read(appUserProvider.notifier).removeAccount(linkedAccount);
            context.read(firestoreProvider).updateUser();
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        ),
      ];

  void onAccountTap(LinkedAccount e) {
    kOpenLink(e.fullLink!);
  }
}

class _MyMediasRow extends HookWidget {
  const _MyMediasRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = useProvider(firebaseStorageProvider.select((value) => value.isLoading));

    return Column(
      children: [
        Row(
          children: [
            'My Medias'.text.xl2.semiBold.make().expand(),
            HookBuilder(
              builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.add,
                    color: context.primaryColor,
                  ),
                  onPressed: () {
                    AddMediaSheet.openMediaSheet(context);
                  },
                );
              },
            )
          ],
        ),
        if (isLoading)
          const LinearProgressIndicator(
            minHeight: 2,
          ).scale(scaleValue: 2)
      ],
    );
  }
}

class _MyMediasBuilder extends HookWidget {
  const _MyMediasBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medias = useProvider(appUserProvider.select((value) => value!.linkedMedias))!
        .sortedByNum((element) => element.timestamp!)
        .reversed
        .toList();

    if (medias.isEmpty) {
      return const NoMediasWidget();
    }

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.9,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: medias.map((media) {
        if (media.isImage) {
          return ImagePreviewBuilder(url: media.url);
        }
        if (media.isVideo) {
          return VideoPreviewBuilder(url: media.url);
        }
        if (media.isPdf) {
          return PdfPreviewBuilder(url: media.url);
        }
        return Container();
      }).toList(),
    );
  }
}

class ImagePreviewBuilder extends StatelessWidget {
  const ImagePreviewBuilder({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to<void>(() => ImageViewer(url: url));
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadius),
            child: CachedNetworkImage(
              imageUrl: url,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              placeholder: kImagePlaceHodler,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            width: double.infinity,
            height: double.infinity,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.image,
              color: context.canvasColor.withOpacity(0.9),
            ),
          ).p4()
        ],
      ),
    );
  }
}

final urlToFileProvider = FutureProvider.family<File, String>((ref, url) {
  return DefaultCacheManager().getSingleFile(url);
});

class PdfPreviewBuilder extends HookWidget {
  const PdfPreviewBuilder({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return useProvider(urlToFileProvider(url)).when(
      data: (pdfFile) {
        return GestureDetector(
          onTap: () {
            Get.to<void>(() => PdfFileViewer(url: url, pdfFile: pdfFile));
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(kBorderRadius),
                child: PdfDocumentLoader.openFile(
                  pdfFile.path,
                  pageNumber: 1,
                  pageBuilder: (context, textureBuilder, pageSize) => textureBuilder(),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(kBorderRadius),
                ),
                width: double.infinity,
                height: double.infinity,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.picture_as_pdf,
                  color: context.canvasColor.withOpacity(0.9),
                ),
              ).p4()
            ],
          ),
        );
      },
      loading: () => const CupertinoActivityIndicator(),
      error: (e, s) => e.toString().text.red400.makeCentered(),
    );
  }
}

final videoThumbnailProvider = FutureProvider.family<Uint8List?, File>((ref, videoFile) {
  return VideoThumbnail.thumbnailData(
    video: videoFile.path,
    quality: 25,
  );
});

class VideoPreviewBuilder extends HookWidget {
  const VideoPreviewBuilder({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return useProvider(urlToFileProvider(url)).when(
      data: (videoFile) {
        return GestureDetector(
          onTap: () {
            Get.to<void>(() => VideoViewer(url: url));
          },
          child: HookBuilder(builder: (context) {
            return useProvider(videoThumbnailProvider(videoFile)).when(
              data: (thumbnail) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      child: Image.memory(
                        thumbnail!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(kBorderRadius),
                      ),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.video_collection_rounded,
                        color: context.canvasColor.withOpacity(0.9),
                      ),
                    ).p4()
                  ],
                );
              },
              loading: () => const CupertinoActivityIndicator(),
              error: (e, s) => e.toString().text.red400.makeCentered(),
            );
          }),
        );
      },
      loading: () => const CupertinoActivityIndicator(),
      error: (e, s) => e.toString().text.red400.makeCentered(),
    );
  }
}
