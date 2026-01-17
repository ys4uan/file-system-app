import 'package:flutter/material.dart';

class ToggleVisibility extends StatelessWidget {
  // show show/hide components
  final bool visible;
  // show widget
  final Widget showChild;
  // hide widget
  final Widget hideChild;

  const ToggleVisibility({
    super.key,
    required this.visible,
    required this.showChild,
    required this.hideChild
  });

  @override
  Widget build(BuildContext context) {
    return visible ? showChild : hideChild;
  }
}
