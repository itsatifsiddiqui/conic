import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../res/res.dart';
import '../../res/validators.dart';
import '../../widgets/custom_widgets.dart';
import 'forgot_password_screen.dart';
import 'widgets/auth_footer.dart';
import 'widgets/auth_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthHeader(
              title: 'Login',
              subtitle: 'Please Login Your Account',
            ),
            0.05.sh.heightBox,
            const _LoginForm(),
            0.05.sh.heightBox,
            const AuthFooter.login(),
          ],
        ).p16().scrollVertical(),
      ),
    );
  }
}

class _LoginForm extends HookWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
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
          ),
          16.heightBox,
          FilledTextField(
            controller: passwordController,
            title: 'Password',
            hintText: 'Please enter your password',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            validator: Validators.passwordValidator,
          ),
          12.heightBox,
          'Forgot password?'
              .text
              .end
              .color(context.adaptive87)
              .lg
              .make()
              .p12()
              .mdClick(() {
            Get.to<void>(() => const ForgotPasswordScreen());
          }).make(),
          12.heightBox,
          PrimaryButton(
            text: 'Login',
            enabled: _formKey.currentState?.validate() ?? false,
            onTap: () {},
          )
        ],
      ),
    );
  }
}
