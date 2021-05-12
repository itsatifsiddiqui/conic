import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../res/res.dart';
import '../../res/validators.dart';
import '../../widgets/custom_widgets.dart';
import 'widgets/auth_header.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthHeader(
              title: 'Reset Password',
              subtitle:
                  'Please Enter Your Email To Get Password Reset Instructions.',
            ).pOnly(right: 0.2.sw),
            0.05.sh.heightBox,
            const _ForgotPasswordForm(),
          ],
        ).p16().scrollVertical(),
      ),
    );
  }
}

class _ForgotPasswordForm extends HookWidget {
  const _ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final _formKey = GlobalObjectKey<FormState>(context);
    final formState = useState<bool>(true);
    return Form(
      onChanged: () {
        formState.value = !formState.value;
      },
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FilledTextField(
            controller: emailController,
            validator: Validators.emailValidator,
            title: 'Email',
            hintText: 'Please enter your email',
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          32.heightBox,
          PrimaryButton(
            text: 'Send Password Reset Email',
            enabled: _formKey.currentState?.validate() ?? false,
            onTap: () {},
          )
        ],
      ),
    );
  }
}
