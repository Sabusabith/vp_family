import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vp_family/core/model/person_model.dart';
import 'package:vp_family/core/services/supabase_services.dart';
import 'package:vp_family/view/home/controller/home_controller.dart';

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

  Person? father;
  Person? mother;
  Person? spouse;

  File? image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.member.name);
    age = TextEditingController(text: widget.member.age.toString());
    place = TextEditingController(text: widget.member.place);

    final c = Get.find<HomeController>();
    father = c.members.firstWhereOrNull((p) => p.id == widget.member.fatherId);
    mother = c.members.firstWhereOrNull((p) => p.id == widget.member.motherId);
    spouse = c.members.firstWhereOrNull((p) => p.id == widget.member.spouseId);
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Member')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: pickImage,
            child: CircleAvatar(
              radius: 48,
              backgroundImage: image != null
                  ? FileImage(image!)
                  : NetworkImage(widget.member.photoUrl) as ImageProvider,
              child: image == null && widget.member.photoUrl.isEmpty
                  ? const Icon(Icons.camera_alt)
                  : null,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: age,
            decoration: const InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: place,
            decoration: const InputDecoration(labelText: 'Place'),
          ),

          const SizedBox(height: 20),

          dropdown(c.members, 'Father', father, (v) => father = v),
          dropdown(c.members, 'Mother', mother, (v) => mother = v),
          dropdown(c.members, 'Spouse', spouse, (v) => spouse = v),

          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: () => save(context, c),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  Widget dropdown(
    List<Person> list,
    String label,
    Person? value,
    Function(Person?) onChanged,
  ) {
    return DropdownButtonFormField<Person>(
      value: value,
      hint: Text(label),
      items: list
          .where((p) => p.id != widget.member.id)
          .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
          .toList(),
      onChanged: (v) => setState(() => onChanged(v)),
    );
  }

  void pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => image = File(picked.path));
  }

  Future<void> save(BuildContext context, HomeController c) async {
    String photoUrl = widget.member.photoUrl;
    if (image != null) {
      photoUrl = await SupabaseService.uploadImage(image!);
    }

    final updated = await SupabaseService.updateMember(widget.member.id!, {
      'name': name.text.trim(),
      'age': int.tryParse(age.text) ?? 0,
      'place': place.text.trim(),
      'father_id': father?.id,
      'mother_id': mother?.id,
      'spouse_id': spouse?.id,
      'photo_url': photoUrl,
    });

    /// AUTO SPOUSE LINK
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
