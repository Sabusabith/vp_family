import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vp_family/core/model/person_model.dart';
import 'package:vp_family/core/services/supabase_services.dart';
import 'package:vp_family/view/home/controller/home_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

const Color primary = Color(0xFF4CAF50);
const Color scaffoldBackground = Color(0xFFF4F6FA);

class EditMemberScreen extends StatefulWidget {
  final Person member;
  const EditMemberScreen({super.key, required this.member});

  @override
  State<EditMemberScreen> createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> {
  late TextEditingController name;
  late TextEditingController age;
  late TextEditingController place;
  late TextEditingController _whatsapp;

  Person? father;
  Person? mother;
  Person? spouse;

  File? image;
  Uint8List? webImage;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.member.name);
    age = TextEditingController(text: widget.member.age.toString());
    place = TextEditingController(text: widget.member.place);
    _whatsapp = TextEditingController(text: widget.member.whatsappNumber ?? '');

    final c = Get.find<HomeController>();
    father = c.members.firstWhereOrNull((p) => p.id == widget.member.fatherId);
    mother = c.members.firstWhereOrNull((p) => p.id == widget.member.motherId);
    spouse = c.members.firstWhereOrNull((p) => p.id == widget.member.spouseId);
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: scaffoldBackground,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(CupertinoIcons.back, color: Colors.white, size: 22),
        ),
        title: Text(
          'Edit Member',
          style: GoogleFonts.phudu(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _imagePicker(),

          const SizedBox(height: 24),

          _field(name, 'Name'),
          _field(age, 'Age', isNumber: true),
          _field(place, 'Place'),
          _field(_whatsapp, 'WhatsApp Number', isNumber: true),

          const SizedBox(height: 20),

          _dropdown(
            c.members,
            'Father',
            (v) => setState(() => father = v),
            father,
          ),
          _dropdown(
            c.members,
            'Mother',
            (v) => setState(() => mother = v),
            mother,
          ),
          _dropdown(
            c.members,
            'Spouse',
            (v) => setState(() => spouse = v),
            spouse,
          ),

          const SizedBox(height: 28),

          ElevatedButton(
            onPressed: () => save(c, context),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- IMAGE PICKER ----------
  Widget _imagePicker() {
    return GestureDetector(
      onTap: pickImage,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [primary.withOpacity(0.7), primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    image: image != null
                        ? DecorationImage(
                            image: FileImage(image!),
                            fit: BoxFit.cover,
                          )
                        : webImage != null
                        ? DecorationImage(
                            image: MemoryImage(webImage!),
                            fit: BoxFit.cover,
                          )
                        : widget.member.photoUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(widget.member.photoUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child:
                      image == null &&
                          webImage == null &&
                          widget.member.photoUrl.isEmpty
                      ? const Center(
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary,
                border: Border.all(color: Colors.white, width: 2),
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- TEXT FIELD ----------
  Widget _field(
    TextEditingController c,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : null,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: primary, width: 2),
          ),
        ),
      ),
    );
  }

  /// ---------- DROPDOWN ----------
  Widget _dropdown(
    List<Person> list,
    String label,
    Function(Person?) onChanged,
    Person? selectedValue,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonHideUnderline(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade400, width: 1.2),
          ),
          child: DropdownButton2<Person>(
            isExpanded: true,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                label,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),
            ),
            value: selectedValue,
            items: list
                .where((p) => p.id != widget.member.id)
                .map(
                  (p) => DropdownMenuItem<Person>(
                    value: p,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(p.photoUrl),
                          backgroundColor: Colors.grey.shade200,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          p.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.arrow_drop_down),
            ),
            focusNode: FocusNode(),
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade400, width: 1.2),
              ),
              elevation: 4,
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: TextEditingController(),
              searchInnerWidgetHeight: 80,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) => item.value!.name
                  .toLowerCase()
                  .contains(searchValue.toLowerCase()),
            ),
          ),
        ),
      ),
    );
  }

  /// ---------- IMAGE PICK ----------
  void pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        webImage = await picked.readAsBytes();
      } else {
        image = File(picked.path);
      }
      setState(() {});
    }
  }

  /// ---------- SAVE MEMBER ----------
  Future<void> save(HomeController c, BuildContext context) async {
    String photoUrl = widget.member.photoUrl;

    if (kIsWeb && webImage != null) {
      photoUrl = await SupabaseService.uploadImageBytes(webImage!);
    } else if (!kIsWeb && image != null) {
      photoUrl = await SupabaseService.uploadImage(image!);
    }

    final updated = await SupabaseService.updateMember(widget.member.id!, {
      'name': name.text.trim(),
      'age': int.tryParse(age.text) ?? 0,
      'place': place.text.trim(),
      'whatsapp_number': _whatsapp.text.trim(),
      'father_id': father?.id,
      'mother_id': mother?.id,
      'spouse_id': spouse?.id,
      'photo_url': photoUrl,
    });

    if (spouse != null) {
      await SupabaseService.updateSpouse(
        spouseId: spouse!.id!,
        personId: updated.id!,
      );
    }

    await c.updateMember(updated);
    context.pop();
  }
}
