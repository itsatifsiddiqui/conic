import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension BuildContextExtended on BuildContext {
  Color get adaptive8 => theme.dividerColor.withOpacity(0.08);
  Color get adaptive12 => theme.dividerColor.withOpacity(0.12);
  Color get adaptive26 => theme.dividerColor.withOpacity(0.26);
  Color get adaptive38 => theme.dividerColor.withOpacity(0.38);
  Color get adaptive45 => theme.dividerColor.withOpacity(0.45);
  Color get adaptive54 => theme.dividerColor.withOpacity(0.54);
  Color get adaptive60 => theme.dividerColor.withOpacity(0.60);
  Color get adaptive70 => theme.dividerColor.withOpacity(0.70);
  Color get adaptive75 => theme.dividerColor.withOpacity(0.75);
  Color get adaptive87 => theme.dividerColor.withOpacity(0.87);
  Color get adaptive => theme.dividerColor;
  Color get shadow =>
      theme.brightness == Brightness.dark ? Colors.transparent : Colors.black12;
}

extension ExtendedStringExtension<T> on String {
  String get capializeAllFirst =>
      split(' ').map((e) => e.capitalizeFirst).toList().join(' ');
}

// extension ExtendedNumExtension<T> on num {
//   String get formattedNumber =>
//       NumberFormat().format(this).split(',').join(' ');
// }

extension ExtendedWidget on Widget {
  SliverToBoxAdapter toBoxAdapter() {
    return SliverToBoxAdapter(child: this);
  }
}

extension ExtendedDate on DateTime {
  bool dateIsEqualTo(DateTime date) =>
      day == date.day && month == date.month && year == date.year;
  bool get isSameDay =>
      day == DateTime.now().day &&
      month == DateTime.now().month &&
      year == DateTime.now().year;
  bool get isYesterDay =>
      day == DateTime.now().subtract(const Duration(days: 1)).day &&
      month == DateTime.now().month &&
      year == DateTime.now().year;
  bool get isTomorrow =>
      day == DateTime.now().add(const Duration(days: 1)).day &&
      month == DateTime.now().month &&
      year == DateTime.now().year;
  String getAppBarTitle() {
    if (isSameDay) {
      return 'Today';
    } else if (isYesterDay) {
      return 'Yesterday';
    } else if (isTomorrow) {
      return 'Tomorrow';
    } else {
      return DateFormat('dd MMM yyy').format(this);
    }
  }

  String get formatted => DateFormat('dd MMM yyyy').format(this);
  String get requestFormat => DateFormat('yyyy-MM-dd').format(this);
  String get volumeRequestFormat => DateFormat('yyyy-MM-dd hh:mm').format(this);
  String get firstLetter => DateFormat('E').format(this);
  String get dayName => DateFormat('EEEE').format(this);
}
