import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/paginated_docs_provider.dart';
import 'adaptive_progress_indicator.dart';
import 'error_widet.dart';

class PaginatedDocsBuilder extends HookWidget {
  const PaginatedDocsBuilder({
    Key? key,
    required this.options,
    required this.builder,
  }) : super(key: key);

  final PaginationOptions options;
  final Widget Function(BuildContext context, List<DocumentSnapshot> docs) builder;

  @override
  Widget build(BuildContext context) {
    final isLoading = useProvider(
      paginatedDocsProvider(options).select((value) => value.isLoadingMore),
    );
    return Column(
      children: [
        Expanded(
          child: useProvider(
            paginatedDocsProvider(options).select((value) => value.state),
          ).when(
            data: (docs) {
              return NotificationListener(
                // ignore: avoid_types_on_closure_parameters
                onNotification: (ScrollNotification scrollInfo) {
                  final isLoading = context.read(paginatedDocsProvider(options)).isLoadingMore;
                  final isAtEnd = scrollInfo.metrics.pixels >= (scrollInfo.metrics.maxScrollExtent / 100 * 75);
                  if (!isLoading && isAtEnd) {
                    context.read(paginatedDocsProvider(options)).getDocs(loadMore: true);
                  }
                  return true;
                },
                child: builder(context, docs),
              );
            },
            loading: () => const AdaptiveProgressIndicator(),
            error: (e, s) {
              return StreamErrorWidget(
                error: e.toString(),
                onTryAgain: () {
                  context.refresh(paginatedDocsProvider(options));
                },
              );
            },
          ),
        ),
        if (isLoading)
          const SizedBox(
            height: 20,
            child: Center(
              child: LinearProgressIndicator(
                backgroundColor: Colors.white,
                minHeight: 8,
              ),
            ),
          )
      ],
    );
  }
}
