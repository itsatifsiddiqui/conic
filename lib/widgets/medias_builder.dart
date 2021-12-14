import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conic/widgets/info_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:conic/models/linked_media.dart';
import 'package:conic/res/res.dart';
import 'package:conic/screens/tabs_view/my_accounts/image_viewer.dart';
import 'package:conic/screens/tabs_view/my_accounts/pdf_viewer.dart';
import 'package:conic/screens/tabs_view/my_accounts/video_viewer.dart';

import 'no_medias_widget.dart';

class MyMediasBuilder extends HookWidget {
  final List<LinkedMedia> medias;
  final bool isFriend;
  const MyMediasBuilder({
    Key? key,
    required this.medias,
    this.isFriend = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isFriend && medias.isEmpty) {
      return InfoWidget(text: "No Medias").pOnly(top: 32);
    }
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


