import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Contents for the pages
  static const String aboutContent = '''
VP Family is created to bring all Varikka Pulakkal family members closer, across generations.

With VP Family, you can:
- Build and explore the family tree (കുടുംബ വൃക്ഷം കാണുക)
- View relationships and connections across all family members (ബന്ധങ്ങൾ കാണുക)
- Add and edit member profiles (പുതിയ അംഗങ്ങളെ ചേർക്കുക, വിവരങ്ങൾ തിരുത്തുക)
- Share photos, memories, and stories (ഫോട്ടോകൾ, ഓർമ്മകൾ, കഥകൾ പങ്കുവെക്കുക)
- Preserve the legacy and heritage of our family (നമ്മുടെ കുടുംബത്തിന്റെ പാരമ്പര്യം സംരക്ഷിക്കുക)

ഇതെല്ലാം VP Family-ൽ നിങ്ങളുടെ കുടുംബ ബന്ധങ്ങൾ ശക്തിപ്പെടുത്താനും, സന്തോഷം പങ്കുവെക്കാനും, പുതിയ തലമുറയ്ക്ക് ഓർമ്മകൾ സൂക്ഷിക്കാനും സഹായിക്കുന്നു.
''';

  static const String privacyContent = '''
Your Privacy Matters! / നിങ്ങളുടെ സ്വകാര്യത പ്രധാനമാണ്!

At VP Family, we care about your data.

We Collect:
- Names, photos, age, place, WhatsApp number, and family relationships (പേര്, ഫോട്ടോ, വയസ്സ്, സ്ഥലം, ബന്ധങ്ങൾ എന്നിവ)

How We Use It:
- To maintain accurate family trees (കുടുംബ വൃക്ഷങ്ങൾ ശരിയായി സൂക്ഷിക്കുക)
- Display member profiles (അംഗങ്ങളുടെ പ്രൊഫൈലുകൾ കാണിക്കുക)
- Connect family members (കുടുംബ ബന്ധങ്ങൾ ബന്ധിപ്പിക്കുക)

Data Sharing:
- We do not sell or share your data with third parties (നിങ്ങളുടെ വിവരങ്ങൾ വിൽക്കുകയോ, മറ്റ് പക്കകളുമായി പങ്കിടുകയോ ചെയ്യില്ല)

Security:
- All data is stored securely and encrypted where possible (സുരക്ഷിതമായി സൂക്ഷിക്കുകയും എൻക്രിപ്‌ഷൻ ഉപയോഗിക്കുകയും ചെയ്യുന്നു)

By using VP Family, you agree to the above (ഈ നയങ്ങളുമായി നിങ്ങൾ സമ്മതിക്കുന്നു).
''';

  static const String helpContent = '''
Need Help? / സഹായം വേണോ?

Common Questions / സാധാരണ ചോദിക്കുന്ന ചോദ്യങ്ങൾ:
- How do I add a new member? (പുതിയ അംഗത്തെ എങ്ങനെ ചേർക്കാം?)
- How do I edit or delete profiles? (പ്രൊഫൈലുകൾ എഡിറ്റ് ചെയ്യാൻ അല്ലെങ്കിൽ ഡിലീറ്റ് ചെയ്യാൻ എങ്ങനെ?)
- How do I view the family tree? (കുടുംബ വൃക്ഷം എങ്ങനെ കാണാം?)
- How can I connect with other members? (മറ്റ് അംഗങ്ങളുമായി എങ്ങനെ ബന്ധപ്പെടാം?)

Contact Us / ബന്ധപ്പെടുക:
- Email: support@vpfamily.com
- Response time: Within 24 hours / 24 മണിക്കൂറിനുള്ളിൽ

You can also check the in-app tutorials and guidance for tips (ഇൻ-ആപ്പ് ഗൈഡുകൾ, ട്യൂട്ടോറിയലുകൾ പരിശോധിക്കുക).
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.phudu(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('General'),
          _settingsTile(context, Icons.celebration, 'Our Meets', () {
            context.push('/settings/meets');
          }),
          _settingsTile(context, Icons.language, 'Language', () {}),

          const SizedBox(height: 20),

          _sectionTitle('App'),
          _settingsTile(context, Icons.info, 'About App', () {
            context.push(
              '/settings/info',
              extra: {'title': 'About VP Family', 'content': aboutContent},
            );
          }),
          _settingsTile(context, Icons.privacy_tip, 'Privacy Policy', () {
            context.push(
              '/settings/info',
              extra: {'title': 'Privacy Policy', 'content': privacyContent},
            );
          }),
          _settingsTile(context, Icons.help, 'Help & Support', () {
            context.push(
              '/settings/info',
              extra: {'title': 'Help & Support', 'content': helpContent},
            );
          }),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4CAF50),
        ),
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF4CAF50)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
