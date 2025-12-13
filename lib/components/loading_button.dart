import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final bool loading;
  final Color? loadingColor;
  final String text;
  final TextStyle? textStyle;
  final VoidCallback onPressed;

  const LoadingButton({
    super.key,
    required this.loading,
    this.loadingColor,
    required this.text,
    this.textStyle,
    required this.onPressed
  });

  Widget _showLoadingBtn() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(loadingColor ?? Colors.white),
          ),
        ),
        Text(text, style: textStyle)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: loading ? null : onPressed,
      child: loading
        ? _showLoadingBtn()
        : Text(text, style: textStyle)
    );
  }
}
