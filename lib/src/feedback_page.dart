import 'dart:io';
import 'package:flutter/material.dart';
import 'feedback_input.dart';
import 'image_picker_grid.dart';
import 'submit_button.dart';

class FeedbackPage extends StatefulWidget {
  /// 获取当前用户 ID 的回调方法
  final Future<String> Function()? getUserId;

  /// 提交反馈的回调方法，调用者可自行实现 API 请求逻辑
  final Future<void> Function({
  required String userId,
  required String feedbackText,
  required List<File?> images,
  })? onSubmit;

  final String title;

  const FeedbackPage({
    Key? key,
    this.getUserId,
    this.onSubmit,
    this.title = '反馈与建议',
  }) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  List<File?> _selectedImages = List.generate(3, (index) => null);
  String currentUserId = '000000';

  @override
  void initState() {
    super.initState();
    _initUserId();
  }

  Future<void> _initUserId() async {
    if (widget.getUserId != null) {
      currentUserId = await widget.getUserId!();
      setState(() {});
    }
  }

  void _onImageChanged(int index, File? file) {
    _selectedImages[index] = file;
  }

  Future<void> _handleSubmit() async {
    if (_feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请输入反馈内容')));
      return;
    }
    if (_feedbackController.text.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('反馈内容不能超过100字')));
      return;
    }

    // 调用传入的提交回调
    if (widget.onSubmit != null) {
      await widget.onSubmit!(
          userId: currentUserId,
          feedbackText: _feedbackController.text,
          images: _selectedImages);
    } else {
      // 默认行为：显示成功提示
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('反馈已提交 (默认行为)')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : const Color(0xFFFFFFFF),
        title: Text(widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 12.0),
            const Text(
              '请输入您的建议或问题反馈（100 字以内）：',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01101B),
              ),
            ),
            const SizedBox(height: 8),
            FeedbackInput(controller: _feedbackController),
            const SizedBox(height: 16),
            const Text(
              '上传图片（最多 3 张）：',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01101B),
              ),
            ),
            const SizedBox(height: 8),
            ImagePickerGrid(
              onImageChanged: _onImageChanged,
            ),
            const SizedBox(height: 16),
            Container(
              margin:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
              width: double.infinity,
              height: 56,
              child: SubmitButton(
                onPressed: _handleSubmit,
                icon: Icons.send,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
