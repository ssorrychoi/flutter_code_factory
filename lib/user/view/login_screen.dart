import 'package:flutter/material.dart';
import 'package:flutter_code_factory/common/component/custom_text_form_field.dart';
import 'package:flutter_code_factory/common/const/colors.dart';
import 'package:flutter_code_factory/common/layout/default_layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Title(),
                const SizedBox(height: 16),
                _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요',
                  onChanged: (value) {},
                  isObscureText: true,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(primary: PRIMARY_COLOR),
                    child: Text('로그인'),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(primary: Colors.black),
                    child: Text('회원가입'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
