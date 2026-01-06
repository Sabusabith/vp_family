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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        toolbarHeight: 80,
        title: Obx(() {
          return controller.isSearching.value
              ? SizedBox(
                  height: 42,
                  child: TextField(
                    autofocus: true,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'Search member...',
                      hintStyle: TextStyle(color: Colors.white70),
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
                    onChanged: controller.setSearch,
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

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio: 0.75,
          ),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];

            return GestureDetector(
              onTap: () {
                context.push('/home/member/${member.id}');
              },
              child: Card(
                elevation: 6,
                shadowColor: Colors.black26,
                color: theme.cardColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: primary.withOpacity(0.6)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  height: 140, // total card height
                  width: 100, // card width
                  child: Column(
                    children: [
                      // ---------------- IMAGE (TOP HALF) ----------------
                      Expanded(
                        flex: 3, // 50% of card
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: member.photoUrl.isEmpty
                                ? primary.withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
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
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                  ),
                                )
                              : null,
                        ),
                      ),

                      // ---------------- TEXT (BOTTOM HALF) ----------------
                      Expanded(
                        flex: 2, // remaining 50%
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                member.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.publicSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: theme.textTheme.bodyLarge!.color,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 3,
                                    bottom: 3,
                                    left: 8,
                                    right: 8,
                                  ),
                                  child: Text(
                                    'View profile',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        elevation: 6,
        onPressed: () => context.push('/home/add'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
