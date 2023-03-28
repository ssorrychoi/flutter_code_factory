import 'package:flutter/material.dart';
import 'package:flutter_code_factory/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool isObscureText;
  final bool isAutoFocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.errorText,
    this.isObscureText = false,
    this.isAutoFocus = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1,
      ),
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: isObscureText, //  비밀번호 입력할때
      autofocus: isAutoFocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),
        fillColor: INPUT_BG_COLOR,
        filled: true,
        enabledBorder: baseBorder,
        border: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }
}
