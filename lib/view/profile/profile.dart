// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vp_family/core/model/person_model.dart';
// import 'package:vp_family/view/home/controller/home_controller.dart';
// import 'package:go_router/go_router.dart';
// import 'package:vp_family/core/services/supabase_services.dart';
// import 'package:vp_family/utils/common/app_colors.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<HomeController>();

//     // Hardcoded "logged in" user — you can also pick the first member
//     final Person loggedInUser = controller.members.isNotEmpty
//         ? controller.members.first
//         : Person(
//             id: '0',
//             name: 'Your Name',
//             age: 30,
//             place: 'Your City',
//             whatsappNumber: '1234567890',
//             photoUrl: '',
//           );

//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile'), backgroundColor: primary),
//       body: ListView(
//         padding: const EdgeInsets.all(20),
//         children: [
//           // ---------------- PROFILE HEADER ----------------
//           _profileHeader(context, loggedInUser, controller),

//           const SizedBox(height: 30),

//           // ---------------- PROFILE OPTIONS ----------------
//           _profileTile(
//             Icons.person,
//             'Edit Profile',
//             onTap: () {
//               context.push('/home/member/${loggedInUser.id}/edit');
//             },
//           ),
//           _profileTile(
//             Icons.photo,
//             'Change Photo',
//             onTap: () {
//               context.push('/home/member/${loggedInUser.id}/edit');
//             },
//           ),
//           _profileTile(
//             Icons.family_restroom,
//             'My Family',
//             onTap: () {
//               context.push('/home/tree/${loggedInUser.id}');
//             },
//           ),
//           _profileTile(
//             Icons.logout,
//             'Logout',
//             isLogout: true,
//             onTap: () {
//               // For hardcoded login, just pop to login screen
//               context.pop();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   /// ---------------- HEADER ----------------
//   Widget _profileHeader(
//     BuildContext context,
//     Person user,
//     HomeController controller,
//   ) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 55,
//           backgroundColor: const Color(0xFF4CAF50),
//           child: CircleAvatar(
//             radius: 52,
//             backgroundImage: user.photoUrl.isNotEmpty
//                 ? NetworkImage(user.photoUrl)
//                 : const NetworkImage('https://via.placeholder.com/150'),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           user.name,
//           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           user.whatsappNumber ?? 'familytree@app.com',
//           style: TextStyle(color: Colors.grey[600]),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (user.age != 0) ...[
//               const Icon(Icons.cake, size: 16, color: Colors.grey),
//               const SizedBox(width: 4),
//               Text(
//                 '${user.age} years',
//                 style: TextStyle(color: Colors.grey.shade700),
//               ),
//               const SizedBox(width: 16),
//             ],
//             const Icon(Icons.location_on, size: 16, color: Colors.grey),
//             const SizedBox(width: 4),
//             Text(user.place, style: TextStyle(color: Colors.grey.shade700)),
//           ],
//         ),
//       ],
//     );
//   }

//   /// ---------------- PROFILE TILE ----------------
//   Widget _profileTile(
//     IconData icon,
//     String title, {
//     bool isLogout = false,
//     VoidCallback? onTap,
//   }) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       child: ListTile(
//         leading: Icon(icon, color: isLogout ? Colors.red : primary),
//         title: Text(
//           title,
//           style: TextStyle(color: isLogout ? Colors.red : Colors.black),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }
// }
