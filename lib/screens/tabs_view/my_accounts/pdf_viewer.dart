import 'dart:io';

import 'package:conic/providers/firestore_provider.dart';
import 'package:conic/res/platform_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

import 'package:conic/models/linked_media.dart';

import '../../../res/res.dart';
import '../../../widgets/adaptive_progress_indicator.dart';

class PdfFileViewer extends StatelessWidget {
  const PdfFileViewer({
    Key? key,
    required this.url,
    required this.pdfFile,
    required this.media,
  }) : super(key: key);
  final String url;
  final File pdfFile;
  final LinkedMedia media;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
      body: PdfViewer.openFile(
        pdfFile.path,
        params: PdfViewerParams(
          buildPagePlaceholder: (context, pageNumber, pageRect) {
            return const AdaptiveProgressIndicator();
          },
          pageDecoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -4),
                spreadRadius: 4,
                blurRadius: 12,
                color: context.adaptive12,
              )
            ],
          ),
        ),
      ),
    );
  }
}
