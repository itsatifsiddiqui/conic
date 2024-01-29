import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

Future<void> readNfcTag({
  required BuildContext context,
  required Future<String?> Function(NfcTag) handleTag,
  String alertMessage = 'Hold your device above the nfc tag',
}) async {
  if (Platform.isIOS) {
    return NfcManager.instance.startSession(
      alertMessage: alertMessage,
      onDiscovered: (tag) async {
        try {
          final result = await handleTag(tag);
          await NfcManager.instance.stopSession(alertMessage: result);
        } catch (e) {
          await NfcManager.instance.stopSession(errorMessage: '$e');
        }
      },
    );
  }
  return showDialog(
    context: context,
    builder: (context) => _AndroidNfcDialog(
      alertMessage: alertMessage,
      handleTag: handleTag,
    ),
  );
}

class _AndroidNfcDialog extends StatefulWidget {
  const _AndroidNfcDialog({
    required this.handleTag,
    required this.alertMessage,
  });

  final String alertMessage;

  final Future<String?>? Function(NfcTag tag) handleTag;

  @override
  State<StatefulWidget> createState() => _AndroidNfcDialogState();
}

class _AndroidNfcDialogState extends State<_AndroidNfcDialog> {
  String _alertMessage = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          final result = await widget.handleTag(tag);
          await NfcManager.instance.stopSession();
          setState(() => _alertMessage = result ?? '');
        } catch (e) {
          await NfcManager.instance.stopSession().catchError((dynamic e) {/* no op */});
          setState(() => _errorMessage = '$e');
        }
      },
    ).catchError((dynamic e) => setState(() => _errorMessage = '$e'));
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession().catchError((dynamic e) {/* no op */});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _errorMessage.isNotEmpty == true
            ? 'Error'
            : _alertMessage.isNotEmpty == true
                ? 'Success'
                : 'Ready to scan',
      ),
      content: Text(
        _errorMessage.isNotEmpty == true
            ? _errorMessage
            : _alertMessage.isNotEmpty == true
                ? _alertMessage
                : widget.alertMessage,
      ),
      actions: [
        // ignore: deprecated_member_use
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            _errorMessage.isNotEmpty == true
                ? 'Got it'
                : _alertMessage.isNotEmpty == true
                    ? 'OK'
                    : 'Cancel',
          ),
        ),
      ],
    );
  }
}
