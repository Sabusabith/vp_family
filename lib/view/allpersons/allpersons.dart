import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vp_family/core/model/person_model.dart';
import 'package:vp_family/view/home/controller/home_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:vp_family/utils/common/app_colors.dart';

class AllMembersScreen extends StatelessWidget {
  const AllMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Family Members'),
        backgroundColor: primary,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator(color: primary));
        }

        // Filtered members based on search query
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
            // Search field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: controller.setSearch,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: primaryDark.withOpacity(.8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: primaryDark.withOpacity(.8)),
                  ),
                  hintText: 'Search members...',
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                ),
              ),
            ),

            // Member list
            Expanded(
              child: members.isEmpty
                  ? const Center(
                      child: Text(
                        'No members found.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: member.photoUrl.isNotEmpty
                                  ? NetworkImage(member.photoUrl)
                                  : null,
                              child: member.photoUrl.isEmpty
                                  ? Text(
                                      member.name[0],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: primary,
                                      ),
                                    )
                                  : null,
                            ),
                            title: Text(
                              member.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '${member.age} yrs • ${member.place}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                            onTap: () {
                              context.push('/home/member/${member.id}');
                            },
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
