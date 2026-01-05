import 'package:get/get.dart';
import 'package:vp_family/core/model/person_model.dart';
import 'package:vp_family/core/services/supabase_services.dart';

class HomeController extends GetxController {
  final members = <Person>[].obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMembers();
  }

  Future<void> updateMember(Person updated) async {
    final index = members.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      members[index] = updated;
    }
  }

  Future<void> fetchMembers() async {
    loading.value = true;
    members.value = await SupabaseService.fetchMembers();
    loading.value = false;
  }

  Future<Person> addMember(Person person) async {
    final created = await SupabaseService.addMember(person);
    members.add(created);
    return created;
  }
}
