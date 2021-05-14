import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';

Future<String?> writeTag(NfcTag tag, Uri uri) async {
  final tech = Ndef.from(tag);
  if (tech == null) {
    return 'ERROR: Tag is not compatible with NDEF.';
  }
  if (!tech.isWritable) {
    return 'ERROR: Tag is not writable.';
  }

  try {
    await tech.write(NdefMessage([NdefRecord.createUri(uri)]));
  } on PlatformException catch (_) {
    return 'Exception: Some error has occurred.';
  }

  return 'Success';
}
