import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphite/graphite.dart';
import 'package:vp_family/core/model/person_model.dart';
import 'package:vp_family/utils/common/app_colors.dart';
import 'package:vp_family/view/home/controller/home_controller.dart';

class AllFamilyTreeScreen extends StatelessWidget {
  const AllFamilyTreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final members = Get.find<HomeController>().members;

    if (members.isEmpty) {
      return const Scaffold(body: Center(child: Text('No family data')));
    }

    // Build Graphite JSON data
    final jsonData = _buildGraphiteJson(members);

    // Convert JSON string to List<NodeInput>
    final nodeList = nodeInputFromJson(jsonEncode(jsonData));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(CupertinoIcons.back, color: Colors.white, size: 22),
        ),
        title: Text(
          'All Family Tree',
          style: GoogleFonts.phudu(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [primary, primaryDark]),
          ),
        ),
      ),
      body: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(1000),
        minScale: 0.1,
        maxScale: 4,
        child: DirectGraph(
          list: nodeList,
          defaultCellSize: const Size(140, 140),
          cellPadding: const EdgeInsets.all(16),
          orientation: MatrixOrientation.Vertical,

          nodeBuilder: (context, node) {
            // `node.id` is the person’s ID
            final id = node.id;
            final p = members.firstWhere((p) => p.id == id);
            return _memberWidget(p, context);
          },
          centered: true,

          styleBuilder: (edge) => EdgeStyle(lineStyle: LineStyle.solid),
        ),
      ),
    );
  }

  /// Build Graphite-compatible JSON
  List<Map<String, dynamic>> _buildGraphiteJson(List<Person> members) {
    final list = <Map<String, dynamic>>[];

    // Create baseline entries
    for (final p in members) {
      // Only include nodes with a non-null id
      if (p.id != null) {
        list.add({"id": p.id, "next": []});
      }
    }

    // Quick lookup map
    final map = {for (var m in list) m["id"] as String: m};

    // Parent → child edges
    for (final child in members) {
      final childId = child.id;
      if (childId == null) continue;

      if (child.fatherId != null && map.containsKey(child.fatherId)) {
        (map[child.fatherId]!["next"] as List).add({"outcome": childId});
      }
      if (child.motherId != null && map.containsKey(child.motherId)) {
        (map[child.motherId]!["next"] as List).add({"outcome": childId});
      }
      // Optional: spouse link (single direction)
      if (child.spouseId != null && map.containsKey(child.spouseId)) {
        (map[child.id]!["next"] as List).add({"outcome": child.spouseId});
      }
    }

    return list;
  }

  Widget _memberWidget(Person member, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => context.push('/home/member/${member.id}'),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: primary, width: 1.5),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: primary,
              backgroundImage: member.photoUrl.isNotEmpty
                  ? NetworkImage(member.photoUrl)
                  : null,
              child: member.photoUrl.isEmpty
                  ? Text(
                      member.name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          member.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
