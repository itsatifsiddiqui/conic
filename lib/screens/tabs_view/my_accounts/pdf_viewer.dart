import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

import '../../../res/res.dart';
import '../../../widgets/adaptive_progress_indicator.dart';

class PdfFileViewer extends StatelessWidget {
  const PdfFileViewer({
    Key? key,
    required this.url,
    required this.pdfFile,
  }) : super(key: key);
  final String url;
  final File pdfFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
