import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../res/res.dart';
import '../../res/validators.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_widgets.dart';
import '../nfc/activate_nfc_screen.dart';
import 'auth_footer.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthHeader(
              title: 'Sign up',
              subtitle: 'Please create your account',
            ),
            0.05.sh.heightBox,
            const _SignupForm(),
            0.05.sh.heightBox,
            const AuthFooter.signup(),
          ],
        ).p16().scrollVertical(),
      ),
    );
  }
}

class _SignupForm extends HookWidget {
  const _SignupForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
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
            controller: nameController,
            title: 'Name',
            hintText: 'Please enter your name',
            prefixIcon: const Icon(Icons.person_outline_rounded),
            validator: Validators.emptyValidator,
            textInputAction: TextInputAction.next,
          ),
          16.heightBox,
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
            onSubmitAction: () => register(
              nameController.text.trim(),
              emailController.text.trim(),
              passwordController.text.trim(),
              _formKey,
              context,
            ),
          ),
          32.heightBox,
          PrimaryButton(
            text: 'Sign up',
            enabled: _formKey.currentState?.validate() ?? false,
            onTap: () => register(
              nameController.text.trim(),
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

  void register(
    String name,
    String email,
    String password,
    GlobalObjectKey<FormState> formKey,
    BuildContext context,
  ) {
    FocusScope.of(context).unfocus();
    Get.offAll<void>(() => const ActivateNfcScreen());
  }
}
