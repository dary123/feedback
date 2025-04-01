import 'package:flutter/material.dart';

class FeedbackInput extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle? textStyle;
  final InputDecoration? decoration;
  final int maxLength;
  final int maxLines;

  const FeedbackInput({
    Key? key,
    required this.controller,
    this.textStyle,
    this.decoration,
    this.maxLength = 100,
    this.maxLines = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: textStyle,
      decoration: decoration ??
          InputDecoration(
            hintText: '请输入您的反馈...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
      maxLength: maxLength,
      maxLines: maxLines,
    );
  }
}
