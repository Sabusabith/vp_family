import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vp_family/utils/common/app_colors.dart';
import 'package:vp_family/view/home/controller/home_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:vp_family/view/person/member_profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(title: const Text('Family Members')),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final members = controller.members;

        if (members.isEmpty) {
          return const Center(
            child: Text(
              'No family members yet.',
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
            childAspectRatio: 0.8,
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
                  CircleAvatar(
                    radius: 40,
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
