import 'package:flutter/material.dart';
import 'package:vp_family/utils/common/app_colors.dart';

class TreeLinePainter extends CustomPainter {
  final int parentCount;
  final int childCount;
  final double nodeWidth;
  final double nodeSpacing;
  final bool drawParentToMember;
  final bool drawMemberToChildren;

  TreeLinePainter({
    this.parentCount = 0,
    this.childCount = 0,
    this.nodeWidth = 80,
    this.nodeSpacing = 32,
    this.drawParentToMember = false,
    this.drawMemberToChildren = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primary
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;

    // -------- Parents → Member --------
    if (drawParentToMember && parentCount > 0) {
      final topY = 0.0;
      final horizontalY = size.height * 0.3;
      final memberY = size.height * 0.7;

      // Horizontal line connecting all parents
      double parentsTotalWidth =
          parentCount * nodeWidth + (parentCount - 1) * nodeSpacing;
      final startX = centerX - parentsTotalWidth / 2 + nodeWidth / 2;
      final endX = centerX + parentsTotalWidth / 2 - nodeWidth / 2;
      canvas.drawLine(
        Offset(startX, horizontalY),
        Offset(endX, horizontalY),
        paint,
      );

      // Vertical lines from each parent to horizontal line
      for (int i = 0; i < parentCount; i++) {
        double x = startX + i * (nodeWidth + nodeSpacing);
        canvas.drawLine(
          Offset(x, topY + nodeWidth / 2),
          Offset(x, horizontalY),
          paint,
        );
      }

      // Vertical line from horizontal line to member
      canvas.drawLine(
        Offset(centerX, horizontalY),
        Offset(centerX, memberY),
        paint,
      );
    }

    // -------- Member → Children --------
    if (drawMemberToChildren && childCount > 0) {
      final topY = 0.0;
      final horizontalY = size.height * 0.3;

      double childrenTotalWidth =
          childCount * nodeWidth + (childCount - 1) * nodeSpacing;
      final startX = centerX - childrenTotalWidth / 2 + nodeWidth / 2;
      final endX = centerX + childrenTotalWidth / 2 - nodeWidth / 2;

      // Vertical line from member to horizontal line
      canvas.drawLine(
        Offset(centerX, topY),
        Offset(centerX, horizontalY),
        paint,
      );

      // Horizontal line connecting children
      canvas.drawLine(
        Offset(startX, horizontalY),
        Offset(endX, horizontalY),
        paint,
      );

      // Vertical line from horizontal line to each child
      for (int i = 0; i < childCount; i++) {
        double x = startX + i * (nodeWidth + nodeSpacing);
        canvas.drawLine(
          Offset(x, horizontalY),
          Offset(x, horizontalY + nodeWidth / 2),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
