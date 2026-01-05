import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:vp_family/core/model/person_model.dart';
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

    double nodeWidth = 80;
    double nodeSpacing = 32;

    double parentsRowWidth = parents.isEmpty
        ? 0
        : parents.length * nodeWidth + (parents.length - 1) * nodeSpacing;
    double childrenRowWidth = children.isEmpty
        ? 0
        : children.length * nodeWidth + (children.length - 1) * nodeSpacing;

    return Scaffold(
      appBar: AppBar(title: const Text('Family Tree')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// PARENTS ROW
            if (parents.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < parents.length; i++) ...[
                    _node(context, parents[i]),
                    if (i != parents.length - 1) SizedBox(width: nodeSpacing),
                  ],
                ],
              ),

            /// PARENTS → MEMBER LINES
            if (parents.isNotEmpty)
              CustomPaint(
                size: Size(parentsRowWidth, 80),
                painter: TreeLinePainter(
                  parentCount: parents.length,
                  drawParentToMember: true,
                  nodeWidth: nodeWidth,
                  nodeSpacing: nodeSpacing,
                ),
              ),

            /// MEMBER + SPOUSE
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _node(context, member, isMain: true),
                if (spouse != null) ...[
                  SizedBox(width: nodeSpacing),
                  _node(context, spouse),
                ],
              ],
            ),

            /// MEMBER → CHILDREN LINES
            if (children.isNotEmpty)
              CustomPaint(
                size: Size(childrenRowWidth, 80),
                painter: TreeLinePainter(
                  childCount: children.length,
                  drawMemberToChildren: true,
                  nodeWidth: nodeWidth,
                  nodeSpacing: nodeSpacing,
                ),
              ),

            /// CHILDREN
            if (children.isNotEmpty)
              Wrap(
                alignment: WrapAlignment.start,
                spacing: nodeSpacing,
                runSpacing: 24,
                children: children
                    .map((child) => _node(context, child))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  /// ---------- NODE ----------
  Widget _node(BuildContext context, Person person, {bool isMain = false}) {
    return GestureDetector(
      onTap: () => context.push('/home/member/${person.id}'),
      child: Column(
        children: [
          CircleAvatar(
            radius: isMain ? 34 : 26,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: person.photoUrl.isNotEmpty
                ? NetworkImage(person.photoUrl)
                : null,
            child: person.photoUrl.isEmpty
                ? Text(
                    person.name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: isMain ? 24 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 80,
            child: Text(
              person.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMain ? 14 : 12,
                fontWeight: isMain ? FontWeight.w600 : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
