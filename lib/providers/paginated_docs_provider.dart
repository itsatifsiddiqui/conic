import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const int _limit = 10;

final paginatedDocsProvider =
    ChangeNotifierProvider.family<PaginatedDocsProvider, PaginationOptions>((ref, options) {
  return PaginatedDocsProvider(options);
});

class PaginatedDocsProvider with ChangeNotifier {
  PaginatedDocsProvider(this.options) {
    getDocs();
  }
  final PaginationOptions options;
  bool isLoadingMore = false;
  DocumentSnapshot? lastDoc;

  AsyncValue<List<DocumentSnapshot>> state = const AsyncValue.loading();

  Future<void> getDocs({bool loadMore = false}) async {
    try {
      final collection = FirebaseFirestore.instance.collection(options.path);
      late Query ref;
      if (options.orderBy != null) {
        ref = collection
            .orderBy(options.orderBy!.field, descending: options.orderBy!.descending)
            .limit(_limit);
      } else {
        ref = collection.limit(_limit);
      }

      if (options.whereQuery != null && options.whereQuery!.isEqualTo) {
        ref = ref.where(options.whereQuery!.field!, isEqualTo: options.whereQuery!.condition);
      }
      if (options.whereQuery != null && options.whereQuery!.arrayContains) {
        ref = ref.where(options.whereQuery!.field!, arrayContains: options.whereQuery!.condition);
      }

      log(ref.parameters.toString(), name: 'paginationProvider');

      if (loadMore) {
        if (lastDoc == null) {
          isLoadingMore = false;
          notifyListeners();
          return;
        }
        ref = ref.startAfterDocument(lastDoc!);
        isLoadingMore = true;
        notifyListeners();
      }
      final snapshots = await ref.get();
      if (snapshots.docs.isEmpty) {
        if (!loadMore) {
          state = const AsyncValue.data([]);
        }
        isLoadingMore = false;
        lastDoc = null;
        notifyListeners();
        return;
      }
      lastDoc = snapshots.docs.last;
      final docs = snapshots.docs.map((e) => e).toList();
      final previousDocs = state.data;
      if (previousDocs == null) {
        state = AsyncValue.data(docs);
      } else {
        state = AsyncValue.data([...previousDocs.value, ...docs]);
      }
      isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      state = AsyncValue.error(e);
      notifyListeners();
    }
  }
}

@immutable
class PaginationOptions {
  const PaginationOptions({
    required this.path,
    this.published = true,
    this.whereQuery,
    this.orderBy,
  });
  final String path;
  final bool published;
  final Where? whereQuery;
  final OrderBy? orderBy;

  @override
  String toString() =>
      'PaginationOptions(path: $path, published: $published, whereQuery: $whereQuery)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaginationOptions &&
        other.path == path &&
        other.published == published &&
        other.whereQuery == whereQuery &&
        other.orderBy == orderBy;
  }

  @override
  int get hashCode {
    return path.hashCode ^ published.hashCode ^ whereQuery.hashCode ^ orderBy.hashCode;
  }

  PaginationOptions copyWith({
    String? path,
    bool? published,
    Where? whereQuery,
  }) {
    return PaginationOptions(
      path: path ?? this.path,
      published: published ?? this.published,
      whereQuery: whereQuery ?? this.whereQuery,
    );
  }
}

@immutable
class Where {
  const Where({
    this.field,
    this.isEqualTo = false,
    this.arrayContains = false,
    this.condition,
  });
  final String? field;
  final bool isEqualTo;
  final bool arrayContains;
  final String? condition;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Where &&
        other.field == field &&
        other.isEqualTo == isEqualTo &&
        other.arrayContains == arrayContains &&
        other.condition == condition;
  }

  @override
  int get hashCode {
    return field.hashCode ^ isEqualTo.hashCode ^ arrayContains.hashCode ^ condition.hashCode;
  }
}

@immutable
class OrderBy {
  const OrderBy({
    required this.field,
    this.descending = false,
  });
  final String field;
  final bool descending;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderBy && other.field == field && other.descending == descending;
  }

  @override
  int get hashCode => field.hashCode ^ descending.hashCode;
}
