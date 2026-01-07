import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp_family/core/model/person_model.dart';
import 'package:vp_family/view/home/controller/home_controller.dart';
import 'package:vp_family/utils/common/app_colors.dart';

class AllMembersScreen extends StatelessWidget {
  const AllMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'All Family Members',
          style: GoogleFonts.phudu(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_tree),
            tooltip: 'Family Tree',
            onPressed: () {
              // Navigate to family tree screen
              context.push('/allpersons/allfamily-tree');
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator(color: primary));
        }

        final members =
            controller.isSearching.value && controller.searchQuery.isNotEmpty
            ? controller.members
                  .where(
                    (p) => p.name.toLowerCase().contains(
                      controller.searchQuery.value.toLowerCase(),
                    ),
                  )
                  .toList()
            : controller.members;

        return Column(
          children: [
            /// 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: primary),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: TextField(
                  cursorColor: Colors.grey.shade700,
                  onChanged: controller.setSearch,
                  decoration: InputDecoration(
                    hintText: 'Search family member',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Icon(CupertinoIcons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),

            /// 👥 Members List
            Expanded(
              child: members.isEmpty
                  ? const Center(
                      child: Text(
                        'No members found',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final Person member = members[index];

                        return GestureDetector(
                          onTap: () {
                            context.push('/home/member/${member.id}');
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                /// 👤 Avatar
                                Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green),
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [primary, primaryDark],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: member.photoUrl.isNotEmpty
                                      ? ClipOval(
                                          child: Image.network(
                                            member.photoUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            member.name[0].toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                ),

                                const SizedBox(width: 14),

                                /// ℹ️ Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        member.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${member.age} yrs • ${member.place}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// ➡️ Arrow
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: primary.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
