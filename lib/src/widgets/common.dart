import 'package:flutter/material.dart';

Widget getLoadingPlaceholder(double w, double h) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(h / 7)),
    child: Opacity(
      opacity: 0.3,
      child: Container(
        width: w,
        height: h,
        color: Colors.grey,
        child: LinearProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
              Colors.grey.shade200.withOpacity(0.4)),
        ),
      ),
    ),
  );
}
