import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../providers/auth_provider.dart';
import '../../res/res.dart';
import '../../res/validators.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_widgets.dart';
import 'auth_footer.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                title: 'Login',
                subtitle: 'Please login your account',
              ),
              0.05.sh.heightBox,
              const _LoginForm(),
              0.05.sh.heightBox,
              const AuthFooter.login(),
            ],
          ).p16().scrollVertical(),
        ),
      ),
    );
  }
}

class _LoginForm extends HookWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(
      text: kDebugMode ? 'atif@gmail.com' : '',
    );
    final passwordController = useTextEditingController(
      text: kDebugMode ? '123456' : '',
    );
    final _formKey = GlobalObjectKey<FormState>(context);
    final formState = useState<bool>(true);
    return Form(
      key: _formKey,
      onChanged: () {
        formState.value = !formState.value;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FilledTextField(
            controller: emailController,
            title: 'Email',
            hintText: 'Please enter your email',
            prefixIcon: const Icon(Icons.email_outlined),
            validator: Validators.emailValidator,
            textInputAction: TextInputAction.next,
          ),
          16.heightBox,
          FilledTextField(
            controller: passwordController,
            title: 'Password',
            hintText: 'Please enter your password',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            validator: Validators.passwordValidator,
            textInputAction: TextInputAction.done,
            obscureText: true,
            onSubmitAction: () => login(
              emailController.text.trim(),
              passwordController.text.trim(),
              _formKey,
              context,
            ),
          ),
          'Forgot password?'
              .text
              .end
              .color(context.adaptive87)
              .base
              .make()
              .p12()
              .mdClick(() {
            Get.to<void>(() => const ForgotPasswordScreen());
          }).make(),
          12.heightBox,
          PrimaryButton(
            text: 'Login',
            enabled: _formKey.currentState?.validate() ?? kDebugMode,
            onTap: () => login(
              emailController.text.trim(),
              passwordController.text.trim(),
              _formKey,
              context,
            ),
          )
        ],
      ),
    );
  }

  void login(
    String email,
    String password,
    GlobalObjectKey<FormState> formKey,
    BuildContext context,
  ) {
    FocusScope.of(context).unfocus();
    context.read(authProvider).loginWithEmailAndPassword(email, password);
  }
}
