import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final IconData? icon;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;

  const SubmitButton({
    Key? key,
    required this.onPressed,
    this.buttonText = "提交反馈",
    this.icon,
    this.textStyle,
    this.buttonStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle ??
          ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF01101B),
            backgroundColor: Colors.white,
            elevation: 4,
            shadowColor: const Color(0xFF01101B).withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFF01101B), width: 2),
            ),
            padding: EdgeInsets.zero,
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 24,
              color: const Color(0xFF01101B),
            ),
          if (icon != null) const SizedBox(width: 12),
          Text(
            buttonText,
            style: textStyle ??
                const TextStyle(
                  color: Color(0xFF01101B),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
