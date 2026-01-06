import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp_family/utils/common/app_colors.dart';
import 'package:vp_family/view/home/controller/home_controller.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Obx(() {
          return controller.isSearching.value
              ? SizedBox(
                  height: 40,
                  child: TextField(
                    cursorHeight: 18,
                    cursorColor: Colors.grey.shade200,
                    autofocus: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      hintText: 'Search member...',
                      hintStyle: GoogleFonts.publicSans(
                        color: Colors.grey.shade300,
                      ),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey.shade100),
                      ),
                    ),
                    style: GoogleFonts.publicSans(color: Colors.white),
                    onChanged: controller.setSearch,
                  ),
                )
              : const Text('Family Members');
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
                if (controller.isSearching.value) {
                  controller.stopSearch(); // ❌ close search
                } else {
                  controller.startSearch(); // 🔍 open search
                }
              },
            );
          }),
        ],
      ),

      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator(color: primary));
        }

        final members = controller.homeMembers;

        if (members.isEmpty) {
          return const Center(
            child: Text(
              'No family members found.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.6,
          ),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];

            return GestureDetector(
              onTap: () {
                context.push('/home/member/${member.id}');
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryDark, width: 1.5),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
                      backgroundImage: member.photoUrl.isNotEmpty
                          ? NetworkImage(member.photoUrl)
                          : null,
                      child: member.photoUrl.isEmpty
                          ? Text(
                              member.name[0],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4CAF50),
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    member.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () => context.push('/home/add'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
