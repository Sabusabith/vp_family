import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp_family/core/model/person_model.dart';
import 'package:vp_family/utils/common/app_colors.dart';
import 'package:vp_family/view/fam_tree/widget/tree_line.dart';
import 'package:vp_family/view/home/controller/home_controller.dart';

class FamilyTreeScreen extends StatelessWidget {
  final Person member;
  const FamilyTreeScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();

    final parents = <Person>[];
    final father = c.members.firstWhereOrNull((p) => p.id == member.fatherId);
    final mother = c.members.firstWhereOrNull((p) => p.id == member.motherId);
    if (father != null) parents.add(father);
    if (mother != null) parents.add(mother);

    final spouse = c.members.firstWhereOrNull((p) => p.id == member.spouseId);

    final children = c.members
        .where((p) => p.fatherId == member.id || p.motherId == member.id)
        .toList();

    const double nodeWidth = 80.0;
    const double nodeSpacing = 32.0;
    const double lineHeight = 90.0;

    final int coupleCount = spouse == null ? 1 : 2;

    final double parentsRowWidth = parents.isEmpty
        ? 0.0
        : parents.length * nodeWidth + (parents.length - 1) * nodeSpacing;

    final double coupleRowWidth =
        coupleCount * nodeWidth + (coupleCount - 1) * nodeSpacing;

    final double childrenRowWidth = children.isEmpty
        ? 0.0
        : children.length * nodeWidth + (children.length - 1) * nodeSpacing;

    final double maxWidth = [
      parentsRowWidth,
      coupleRowWidth,
      childrenRowWidth,
    ].reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(CupertinoIcons.back, color: Colors.white, size: 22),
        ),
        title: Text(
          'Family Tree',
          style: GoogleFonts.phudu(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(500),
        minScale: 0.5,
        maxScale: 3.5,
        constrained: false,
        child: Center(
          child: SizedBox(
            width: maxWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ---------------- PARENTS ----------------
                if (parents.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < parents.length; i++) ...[
                        _node(context, parents[i]),
                        if (i != parents.length - 1)
                          const SizedBox(width: nodeSpacing),
                      ],
                    ],
                  ),

                /// -------- PARENTS → COUPLE LINES --------
                if (parents.isNotEmpty)
                  CustomPaint(
                    size: Size(maxWidth, lineHeight),
                    painter: TreeLinePainter(
                      parentCount: parents.length,
                      drawParentToMember: true,
                      nodeWidth: nodeWidth,
                      nodeSpacing: nodeSpacing,
                    ),
                  ),

                /// --------------- COUPLE ----------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _node(context, member, isMain: true),
                    if (spouse != null) ...[
                      const SizedBox(width: nodeSpacing),
                      _node(context, spouse),
                    ],
                  ],
                ),

                /// ------------ MARRIAGE LINE -------------
                if (spouse != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: nodeSpacing,
                      height: 2,
                      color: Colors.green,
                    ),
                  ),

                /// -------- COUPLE → CHILDREN LINES -------
                if (children.isNotEmpty)
                  CustomPaint(
                    size: Size(maxWidth, lineHeight),
                    painter: TreeLinePainter(
                      childCount: children.length,
                      drawMemberToChildren: true,
                      nodeWidth: nodeWidth,
                      nodeSpacing: nodeSpacing,
                    ),
                  ),

                /// ---------------- CHILDREN ---------------
                if (children.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < children.length; i++) ...[
                        _node(context, children[i]),
                        if (i != children.length - 1)
                          const SizedBox(width: nodeSpacing),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ---------------- NODE ----------------
  Widget _node(BuildContext context, Person person, {bool isMain = false}) {
    return GestureDetector(
      onTap: () => context.push('/home/member/${person.id}'),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primary),
            ),
            child: CircleAvatar(
              radius: isMain ? 36 : 26,
              backgroundColor: isMain
                  ? Colors.green.shade400
                  : Colors.grey.shade300,
              backgroundImage: person.photoUrl.isNotEmpty
                  ? NetworkImage(person.photoUrl)
                  : null,
              child: person.photoUrl.isEmpty
                  ? Text(
                      person.name[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: isMain ? 24 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 80,
            child: Text(
              person.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isMain ? 14 : 12,
                fontWeight: isMain ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
