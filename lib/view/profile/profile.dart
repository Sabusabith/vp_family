import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Profile Avatar
            const CircleAvatar(
              radius: 55,
              backgroundColor: Color(0xFF4CAF50),
              child: CircleAvatar(
                radius: 52,
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150',
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Name
            const Text(
              'Your Name',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            /// Email / subtitle
            Text(
              'familytree@app.com',
              style: TextStyle(color: Colors.grey[600]),
            ),

            const SizedBox(height: 30),

            /// Profile options
            _profileTile(Icons.person, 'Edit Profile'),
            _profileTile(Icons.photo, 'Change Photo'),
            _profileTile(Icons.family_restroom, 'My Family'),
            _profileTile(Icons.logout, 'Logout', isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _profileTile(IconData icon, String title, {bool isLogout = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : const Color(0xFF4CAF50),
        ),
        title: Text(
          title,
          style: TextStyle(color: isLogout ? Colors.red : Colors.black),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
