import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../providers/auth_provider.dart';
import '../../providers/firestore_provider.dart';
import '../../res/debouncer.dart';
import '../../res/res.dart';
import '../../res/validators.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_widgets.dart';

final userNameCheckerProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, userName) async {
  if (userName.length < 6) {
    return false;
  }
  final completer = Completer<bool>();
  ref.watch(debouncerProvider).run(() async {
    completer.complete(
      await ref.read(firestoreProvider).isUsernameAvailable(userName),
    );
  });

  return completer.future;
});

class UsernameSetupScreen extends HookWidget {
  const UsernameSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =
        useProvider(authProvider.select((value) => value.isLoading));
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeader(
                title: 'Complete Profile',
                subtitle: 'Please choose a username to complete your profile.',
              ).pOnly(right: 0.2.sw),
              0.05.sh.heightBox,
              const _UsernameValidationForm(),
            ],
          ).p16().scrollVertical(),
        ),
      ),
    );
  }
}

class _UsernameValidationForm extends HookWidget {
  const _UsernameValidationForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userNameController = useTextEditingController();
    final _formKey = GlobalObjectKey<FormState>(context);
    final formState = useState<bool>(true);

    final userName = userNameController.text.trim();

    return Form(
      onChanged: () {
        formState.value = !formState.value;
      },
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FilledTextField(
            controller: userNameController,
            validator: Validators.usernameValidator,
            title: 'Username',
            hintText: 'Please enter a username',
            prefixIcon: const Icon(Icons.email_outlined),
            onSubmitAction: () => completeProfile(
              userNameController.text.trim(),
              _formKey,
              context,
            ),
          ),
          32.heightBox,
          useProvider(userNameCheckerProvider(userName)).when(
            data: (value) {
              final isFormValid = _formKey.currentState?.validate() ?? false;
              return PrimaryButton(
                text: value ? 'Finish' : 'username not available',
                enabled: isFormValid && value,
                onTap: () => completeProfile(
                  userNameController.text.trim(),
                  _formKey,
                  context,
                ),
              );
            },
            loading: () {
              return PrimaryButton(
                enabled: false,
                onTap: () {},
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ).pSymmetric(v: 15),
              );
            },
            error: (e, s) {
              return PrimaryButton(
                text: 'ERROR: ${e.toString()}',
                enabled: false,
                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }

  void completeProfile(
    String username,
    GlobalObjectKey<FormState> formKey,
    BuildContext context,
  ) {
    FocusScope.of(context).unfocus();
    context.read(authProvider).completeProfileSetup(username);
  }
}
