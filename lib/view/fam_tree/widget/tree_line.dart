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
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;

    /// ===============================
    /// PARENTS → MEMBER (ORG STYLE)
    /// ===============================
    if (drawParentToMember && parentCount > 0) {
      final parentBottomY = 0.0;
      final jointY = size.height / 2;
      final memberTopY = size.height;

      // Center vertical spine
      canvas.drawLine(
        Offset(centerX, memberTopY),
        Offset(centerX, jointY),
        paint,
      );

      // Horizontal bus
      final totalWidth =
          parentCount * nodeWidth + (parentCount - 1) * nodeSpacing;
      final startX = centerX - totalWidth / 2 + nodeWidth / 2;
      final endX = centerX + totalWidth / 2 - nodeWidth / 2;

      canvas.drawLine(Offset(startX, jointY), Offset(endX, jointY), paint);

      // Vertical drops to parents
      for (int i = 0; i < parentCount; i++) {
        final x = startX + i * (nodeWidth + nodeSpacing);
        canvas.drawLine(Offset(x, jointY), Offset(x, parentBottomY), paint);
      }
    }

    /// ===============================
    /// MEMBER → CHILDREN (ORG STYLE)
    /// ===============================
    if (drawMemberToChildren && childCount > 0) {
      final memberBottomY = 0.0;
      final jointY = size.height / 2;
      final childTopY = size.height;

      // Center vertical spine
      canvas.drawLine(
        Offset(centerX, memberBottomY),
        Offset(centerX, jointY),
        paint,
      );

      // Horizontal bus
      final totalWidth =
          childCount * nodeWidth + (childCount - 1) * nodeSpacing;
      final startX = centerX - totalWidth / 2 + nodeWidth / 2;
      final endX = centerX + totalWidth / 2 - nodeWidth / 2;

      canvas.drawLine(Offset(startX, jointY), Offset(endX, jointY), paint);

      // Vertical drops to children
      for (int i = 0; i < childCount; i++) {
        final x = startX + i * (nodeWidth + nodeSpacing);
        canvas.drawLine(Offset(x, jointY), Offset(x, childTopY), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
