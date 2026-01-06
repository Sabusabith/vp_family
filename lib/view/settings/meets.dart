import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vp_family/view/person/add_person/add_person.dart';

class MeetsScreen extends StatelessWidget {
  const MeetsScreen({super.key});

  // Sample list of celebrations
  final List<Map<String, String>> meets = const [
    {
      'title': 'Family Get-Together',
      'date': '10-12-2024',
      'url':
          'https://www.facebook.com/100000483005643/videos/1593713048175369/',
    },
    {
      'title': 'Family Get-Together',
      'date': '03-01-2026',
      'url': 'https://photos.app.goo.gl/ZdMKbyYpacYym1J59',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(CupertinoIcons.back, color: Colors.white, size: 22),
        ),
        title: Text(
          'Family Meets',
          style: GoogleFonts.phudu(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: meets.length,
        itemBuilder: (context, index) {
          final meet = meets[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              title: Text(
                meet['title']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                meet['date']!,
                style: const TextStyle(color: primary),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => openUrl(meet['url']!, context),
            ),
          );
        },
      ),
    );
  }

  /// Open URL in browser

  Future<void> openUrl(String url, BuildContext context) async {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid URL: $url')));
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        _showCopyDialog(context, url);
      }
    } catch (e) {
      _showCopyDialog(context, url);
    }
  }

  void _showCopyDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Open Link Manually'),
        content: Text(
          'Cannot open this link automatically.\n\nYou can copy it and open it in the Google Photos app or browser:\n\n$url',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link copied to clipboard')),
              );
            },
            child: const Text('Copy Link'),
          ),
        ],
      ),
    );
  }
}
