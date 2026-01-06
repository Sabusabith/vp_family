import 'package:get/get.dart';
import 'package:vp_family/core/model/person_model.dart';
import 'package:vp_family/core/services/supabase_services.dart';

class HomeController extends GetxController {
  final members = <Person>[].obs;
  final loading = false.obs;

  // 🔍 Search state
  final isSearching = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMembers();
  }

  /// 🏠 Members shown on Home
  /// - Normal → first 6 added
  /// - Searching → ALL matching members
  List<Person> get homeMembers {
    // 🔍 SEARCH MODE
    if (isSearching.value && searchQuery.isNotEmpty) {
      return members
          .where(
            (p) =>
                p.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
          )
          .toList();
    }

    // 🏠 NORMAL MODE
    return members.length > 6 ? members.take(6).toList() : members.toList();
  }

  /// Start search mode
  void startSearch() {
    isSearching.value = true;
  }

  /// Update search text
  void setSearch(String value) {
    searchQuery.value = value;
    isSearching.value =
        value.isNotEmpty; // 🔹 enable search whenever text exists
  }

  /// Stop search and reset
  void stopSearch() {
    isSearching.value = false;
    searchQuery.value = '';
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
