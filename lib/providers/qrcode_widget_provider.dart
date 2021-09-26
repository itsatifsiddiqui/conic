import 'dart:convert';
import 'dart:developer';

import 'package:conic/providers/app_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'base_provider.dart';

const kGroupId = 'group.com.conicqrcode';

const kQrCodeId = 'qrCodeData';

final qrcodeWidgetProvider = ChangeNotifierProvider<QRCodeWidgetProvider>((ref) {
  return QRCodeWidgetProvider(ref.read);
});

class QRCodeWidgetProvider extends BaseProvider {
  QRCodeWidgetProvider(this._read) {
    setQrCodeWidget();
  }

  final Reader _read;

  static Future<void> init() async {}

  Future<void> setQrCodeWidget() async {
    final link = _read(appUserProvider)?.link;
    if (link == null) return;
    final data = FlutterWidgetData(link);

    final qrCodeData = await WidgetKit.getItem(kQrCodeId, kGroupId) as String?;

    if (qrCodeData != null) {
      _log(qrCodeData);
    }

    await WidgetKit.setItem(kQrCodeId, jsonEncode(data), kGroupId);

    _log('Link is set to Widget!!!!');
    WidgetKit.reloadAllTimelines();
  }

  Future<void> removeQrCodeWidget() async {
    await WidgetKit.removeItem(kQrCodeId, kGroupId);
    _log('Link is removed from widget');
    WidgetKit.reloadAllTimelines();
  }

  void _log(String text) => log(text.toString(), name: 'QRCodeWidgetProvider');
}

@immutable
class FlutterWidgetData {
  const FlutterWidgetData(this.text);
  FlutterWidgetData.fromJson(Map<String, dynamic> json) : text = json['text'] as String;

  final String text;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'text': text,
      };
}
