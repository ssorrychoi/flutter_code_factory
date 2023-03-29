import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_factory/common/component/custom_text_form_field.dart';
import 'package:flutter_code_factory/common/const/colors.dart';
import 'package:flutter_code_factory/common/const/data.dart';
import 'package:flutter_code_factory/common/layout/default_layout.dart';
import 'package:flutter_code_factory/common/view/root_tab.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userName = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    final emulatorIp = '10.0.2.2:3000';
    final simulatorIp = '127.0.0.1:3000';

    final ip = Platform.isIOS ? simulatorIp : emulatorIp;

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
                  onChanged: (value) {
                    userName = value;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요',
                  onChanged: (value) {
                    password = value;
                  },
                  isObscureText: true,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final rawString = '$userName:$password';

                      print(rawString);

                      Codec<String, String> stringToBase64 = utf8.fuse(base64);

                      String token = stringToBase64.encode(rawString);

                      final result = await dio.post(
                        'http://$ip/auth/login',
                        options: Options(
                          headers: {
                            'authorization': 'Basic $token',
                          },
                        ),
                      );

                      final accessToken = result.data['accessToken'];
                      final refreshToken = result.data['refreshToken'];

                      await storage.write(
                          key: REFRESH_TOKEN_KEY, value: refreshToken);
                      await storage.write(
                          key: ACCESS_TOKEN_KEY, value: accessToken);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RootTab(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(primary: PRIMARY_COLOR),
                    child: Text('로그인'),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      final result = await dio.post(
                        'http://$ip/auth/token',
                        options: Options(
                          headers: {
                            'authorization':
                                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTY4MDEwMzAxMSwiZXhwIjoxNjgwMTg5NDExfQ.KiwlPsFccnDmG5XsHoxiTJhNGOltIr30jQ3OYQRPgIc',
                          },
                        ),
                      );

                      print(result.data);
                    },
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
