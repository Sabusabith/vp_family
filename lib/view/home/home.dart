import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:vp_family/utils/common/app_colors.dart';
import 'package:vp_family/view/home/controller/home_controller.dart';
import 'package:vp_family/core/model/person_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // ================= APP BAR =================
      appBar: AppBar(
        toolbarHeight: 80,
        title: Obx(() {
          return controller.isSearching.value
              ? SizedBox(
                  height: 42,
                  child: TextField(
                    autofocus: true,
                    cursorColor: Colors.white,
                    onChanged: controller.setSearch,
                    decoration: InputDecoration(
                      hintText: 'Search member...',
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : Text(
                  'Family Members',
                  style: GoogleFonts.phudu(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                );
        }),
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(
                controller.isSearching.value
                    ? CupertinoIcons.clear
                    : CupertinoIcons.search,
              ),
              onPressed: () {
                controller.isSearching.value
                    ? controller.stopSearch()
                    : controller.startSearch();
              },
            );
          }),
        ],
      ),

      // ================= BODY =================
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator(color: primary));
        }

        final members = controller.homeMembers;

        if (members.isEmpty) {
          return const Center(
            child: Text(
              'No family members found',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        // ⭐ FEATURED MEMBER (FIRST)
        final Person featured = members.first;
        final List<Person> rest = members.length > 1 ? members.sublist(1) : [];

        return CustomScrollView(
          slivers: [
            // ============ FEATURED CARD ============
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.72,
                    height: 260,
                    child: _MemberCard(
                      member: featured,
                      theme: theme,
                      isFeatured: true,
                      onTap: () {
                        context.push('/home/member/${featured.id}');
                      },
                    ),
                  ),
                ),
              ),
            ),

            // ============ GRID MEMBERS ============
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final member = rest[index];
                  return _MemberCard(
                    member: member,
                    theme: theme,
                    onTap: () {
                      context.push('/home/member/${member.id}');
                    },
                  );
                }, childCount: rest.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 0.68,
                ),
              ),
            ),
          ],
        );
      }),

      // ================= FAB =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        elevation: 6,
        onPressed: () => context.push('/home/add'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ===================================================================
// ===================== MEMBER CARD WIDGET ===========================
// ===================================================================

class _MemberCard extends StatelessWidget {
  final Person member;
  final ThemeData theme;
  final VoidCallback onTap;
  final bool isFeatured;

  const _MemberCard({
    required this.member,
    required this.theme,
    required this.onTap,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isFeatured ? 10 : 6,
        shadowColor: Colors.black26,
        color: theme.cardColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isFeatured ? primary : primary.withOpacity(0.6),
            width: isFeatured ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            // ---------- IMAGE ----------
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: member.photoUrl.isEmpty
                      ? primary.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  image: member.photoUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(member.photoUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: member.photoUrl.isEmpty
                    ? Text(
                        member.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: isFeatured ? 36 : 28,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      )
                    : null,
              ),
            ),

            // ---------- TEXT ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    member.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.publicSans(
                      fontSize: isFeatured ? 18 : 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (!isFeatured)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'View profile',
                        style: TextStyle(fontSize: 9, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
