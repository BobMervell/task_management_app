import 'package:flutter/material.dart';

class CustomPopup {
  static OverlayEntry? _overlayEntry;

  static Future<T?> showPopup<T>({
    required BuildContext context,
    required Widget child,
    Offset? position,
    double? width,
    double? height,
    bool center = false,
  }) async {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: center ? null : position?.dx,
        top: center ? null : position?.dy,
        width: width,
        height: height,
        child: center
            ? Center(child: child)
            : child,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    return await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(); // Return an empty container to satisfy the showModalBottomSheet requirement
      },
    );
  }

  static void hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
