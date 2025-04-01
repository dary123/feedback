import 'dart:io';
import 'package:feedback_sdk/feedback_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback SDK Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FeedbackExamplePage(),
    );
  }
}

class FeedbackExamplePage extends StatelessWidget {
  const FeedbackExamplePage({Key? key}) : super(key: key);

  // 模拟获取当前用户 ID
  Future<String> _getUserId() async {
    await Future.delayed(const Duration(seconds: 1));
    return "123456";
  }

  // 模拟提交反馈的逻辑
  Future<void> _onSubmit({
    required String userId,
    required String feedbackText,
    required List<File?> images,
  }) async {
    if (kDebugMode) {
      print("UserID: $userId");
    }
    if (kDebugMode) {
      print("Feedback: $feedbackText");
    }
    if (kDebugMode) {
      print("Images: $images");
    }
    // 在实际项目中，可在此处调用 API 接口
    await Future.delayed(const Duration(seconds: 2));
    // 提交成功后，可进行后续处理
  }

  @override
  Widget build(BuildContext context) {
    return FeedbackPage(
      getUserId: _getUserId,
      onSubmit: _onSubmit,
    );
  }
}
