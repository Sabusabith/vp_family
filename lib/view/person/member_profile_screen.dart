import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp_family/core/model/person_model.dart';
import 'package:vp_family/core/services/supabase_services.dart';
import 'package:vp_family/utils/common/app_colors.dart';
import 'package:vp_family/view/home/controller/home_controller.dart';

class MemberProfileScreen extends StatelessWidget {
  final Person member;
  const MemberProfileScreen({super.key, required this.member});
  static Timer? _forceDeleteTimer;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();

    final father = c.members.firstWhereOrNull((p) => p.id == member.fatherId);
    final mother = c.members.firstWhereOrNull((p) => p.id == member.motherId);
    final spouse = c.members.firstWhereOrNull((p) => p.id == member.spouseId);

    final children = c.members
        .where((p) => p.fatherId == member.id || p.motherId == member.id)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(CupertinoIcons.back, color: Colors.white, size: 22),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.phudu(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/home/member/${member.id}/edit'),
          ),
          GestureDetector(
            onTap: () => _confirmDelete(context),
            onLongPressStart: (_) => _startForceDeleteTimer(context),
            onLongPressEnd: (_) => _cancelForceDeleteTimer(),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(CupertinoIcons.delete),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          /// PROFILE HEADER
          _profileHeader(),

          const SizedBox(height: 24),

          /// VIEW FAMILY TREE BUTTON
          _treeButton(context),

          const SizedBox(height: 28),

          /// RELATIONSHIPS ROW
          _sectionTitle('Relationships'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _relationCard(context, 'Father', father),
                _relationCard(context, 'Mother', mother),
                _relationCard(context, 'Spouse', spouse),
              ],
            ),
          ),

          const SizedBox(height: 28),

          /// CHILDREN
          _sectionTitle('Children'),
          if (children.isEmpty) _emptyText('No children recorded'),
          if (children.isNotEmpty)
            Wrap(
              spacing: 18,
              runSpacing: 18,
              children: children
                  .map((child) => _childAvatar(context, child))
                  .toList(),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final c = Get.find<HomeController>();
    final pageContext = context; // ✅ Safe context

    showDialog(
      context: context,
      barrierDismissible: true, // allow tap outside to dismiss
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ⚠️ Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                'Delete Member?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Description
              const Text(
                'This member will be removed from the family tree.\n'
                'This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx); // close dialog

                        try {
                          await SupabaseService.safeDeleteMember(member.id!);

                          c.members.removeWhere((p) => p.id == member.id);
                          c.update();

                          pageContext.pop(); // go back
                        } catch (e) {
                          ScaffoldMessenger.of(pageContext).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red.shade300,
                              content: Text(
                                e.toString().replaceFirst('Exception: ', ''),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //force delete...................................
  void _startForceDeleteTimer(BuildContext context) {
    _forceDeleteTimer?.cancel();

    _forceDeleteTimer = Timer(const Duration(seconds: 8), () {
      _showForceDeleteDialog(context);
    });
  }

  void _cancelForceDeleteTimer() {
    _forceDeleteTimer?.cancel();
  }

  void _showForceDeleteDialog(BuildContext context) {
    final c = Get.find<HomeController>();
    final pageContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: secondaryDark),
            SizedBox(width: 8),
            Text('Force Delete Member', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: const Text(
          'This member has children.\n\n'
          'Force deleting will remove this member and '
          'detach them from all children.\n\n'
          'This action cannot be undone.',
          style: TextStyle(color: textPrimary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            onPressed: () async {
              Navigator.pop(ctx);

              await SupabaseService.forceDeleteMember(member.id!);

              c.members.removeWhere((p) => p.id == member.id);
              c.update();

              pageContext.pop();
            },
            child: const Text(
              'Force Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- UI PARTS ----------------

  Widget _profileHeader() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primary),
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // PROFILE IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              member.photoUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          // NAME
          Text(
            member.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // AGE AND PLACE
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (member.age != 0) ...[
                const Icon(Icons.cake, size: 16, color: primary),
                const SizedBox(width: 4),
                Text(
                  '${member.age} years',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(width: 16),
              ],
              Icon(Icons.location_on, size: 16, color: primary),
              const SizedBox(width: 4),
              Text(
                member.place,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              if (member.whatsappNumber != null &&
                  member.whatsappNumber!.isNotEmpty) ...[
                const SizedBox(width: 16),
                Icon(Icons.phone, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  member.whatsappNumber!,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _treeButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => context.push('/home/tree/${member.id}'),
      icon: const Icon(Icons.account_tree_outlined, color: Colors.white),
      label: const Text(
        'View Family Tree',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.green.shade600,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _relationCard(BuildContext context, String label, Person? person) {
    if (person == null) return const SizedBox();

    return GestureDetector(
      onTap: () => context.push('/home/member/${person.id}'),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: primaryDark),
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IMAGE
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: NetworkImage(person.photoUrl),
            ),
            const SizedBox(width: 10),
            // LABEL + NAME
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  person.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _childAvatar(BuildContext context, Person child) {
    return GestureDetector(
      onTap: () => context.push('/home/member/${child.id}'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: NetworkImage(child.photoUrl),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 72,
            child: Text(
              child.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
    );
  }
}
