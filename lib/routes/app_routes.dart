import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:go_router/go_router.dart';
import 'package:vp_family/utils/common/app_colors.dart';
import 'package:vp_family/view/allpersons/allpersons.dart';
import 'package:vp_family/view/auth/login.dart';
import 'package:vp_family/view/bottomnav/bottomnav_scaffold.dart';
import 'package:vp_family/view/fam_tree/fam_tree.dart';
import 'package:vp_family/view/home/controller/home_controller.dart';
import 'package:vp_family/view/home/home.dart';
import 'package:vp_family/view/person/add_person/add_person.dart' hide primary;
import 'package:vp_family/view/person/edit_person/edit_person.dart'
    hide primary;
import 'package:vp_family/view/person/member_profile_screen.dart';
import 'package:vp_family/view/profile/profile.dart';
import 'package:vp_family/view/settings/settings.dart';
import 'package:vp_family/view/splash/splash.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',

    routes: [
      /// SPLASH (outside shell)
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),

      /// MAIN SHELL (Bottom Navigation)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: BottomnavScaffold(navigationShell: navigationShell),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.grey.shade200,
              selectedItemColor: primary,
              selectedIconTheme: IconThemeData(color: primary),
              currentIndex: navigationShell.currentIndex,
              onTap: navigationShell.goBranch,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group_add_sharp),
                  label: 'All Members',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          );
        },
        branches: [
          /// HOME TAB
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'add', // /home/add
                    builder: (context, state) => const AddPersonScreen(),
                  ),
                  GoRoute(
                    path: 'member/:id', // ✅ relative path
                    builder: (context, state) {
                      final memberId = state.pathParameters['id'];
                      final controller = Get.find<HomeController>();

                      final member = controller.members.firstWhereOrNull(
                        (m) => m.id == memberId,
                      );

                      if (member == null) {
                        return const Scaffold(
                          body: Center(child: Text('Member not found')),
                        );
                      }

                      return MemberProfileScreen(member: member);
                    },
                  ),

                  GoRoute(
                    path: 'tree/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      final c = Get.find<HomeController>();
                      final member = c.members.firstWhere((e) => e.id == id);
                      return FamilyTreeScreen(member: member);
                    },
                  ),

                  GoRoute(
                    path: 'member/:id/edit',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      final c = Get.find<HomeController>();
                      final member = c.members.firstWhere((e) => e.id == id);
                      return EditMemberScreen(member: member);
                    },
                  ),
                ],
              ),
            ],
          ),

          /// PROFILE TAB
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/allpersons',
                builder: (context, state) => AllMembersScreen(),
              ),
            ],
          ),

          /// SETTINGS TAB
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Page not found'))),
  );
}
