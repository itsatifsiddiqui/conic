import 'package:flutter/material.dart';

import '../res/constants.dart';
import '../res/res.dart';

class FilledTextField extends StatelessWidget {
  const FilledTextField({
    Key? key,
    required this.controller,
    required this.title,
    this.validator,
    this.obscureText = false,
    this.focusNode,
    this.nextNode,
    this.onSubmitAction,
    this.keyboardType,
    this.disabled = false,
    this.initialText,
    this.helperText,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.textInputAction,
    this.minLines,
    this.maxLines,
  }) : super(key: key);
  final TextEditingController controller;
  final String title;
  final String? Function(String?)? validator;
  final bool obscureText;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final VoidCallback? onSubmitAction;
  final TextInputType? keyboardType;
  final bool disabled;
  final String? initialText;
  final String? helperText;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final int? minLines;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.text.medium.color(context.adaptive60).make().pOnly(left: 4),
        6.heightBox,
        Material(
          shape: Vx.withRounded(kBorderRadius),
          shadowColor: context.shadow,
          elevation: 1,
          child: IgnorePointer(
            ignoring: disabled,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
              child: TextFormField(
                minLines: minLines,
                maxLines: maxLines,
                initialValue: initialText,
                keyboardType: keyboardType,
                focusNode: focusNode,
                obscureText: obscureText,
                controller: controller,
                validator: validator,
                onFieldSubmitted: (_) {
                  if (nextNode != null) {
                    FocusScope.of(context).requestFocus(nextNode);
                  }
                  if (onSubmitAction != null) {
                    onSubmitAction!();
                  }
                },
                textAlignVertical: TextAlignVertical.center,
                textInputAction: textInputAction ??
                    (nextNode == null ? TextInputAction.done : TextInputAction.next),
                decoration: InputDecoration(
                  errorMaxLines: 2,
                  fillColor: context.adaptive8,
                  filled: true,
                  border: InputBorder.none,
                  hintText: hintText,
                  errorStyle: TextStyle(color: Colors.redAccent.shade400),
                  hintStyle: const TextStyle(fontSize: 14),
                  helperText: helperText,
                  helperStyle: TextStyle(color: context.adaptive54),
                  suffixIcon: suffixIcon,
                  prefixIcon: prefixIcon,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
