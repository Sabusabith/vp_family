import 'dart:io';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/person_model.dart';

class SupabaseService {
  static final _client = Supabase.instance.client;

  /// FETCH MEMBERS (exclude soft-deleted)
  static Future<List<Person>> fetchMembers() async {
    final res = await _client
        .from('persons')
        .select()
        .eq('is_deleted', false)
        .order('created_at', ascending: true);

    return (res as List).map((e) => Person.fromJson(e)).toList();
  }

  /// ADD MEMBER
  static Future<Person> addMember(Person person) async {
    final res = await _client
        .from('persons')
        .insert(person.toJson())
        .select()
        .single();

    return Person.fromJson(res);
  }

  /// AUTO SPOUSE LINK
  static Future<void> updateSpouse({
    required String personId,
    required String spouseId,
  }) async {
    await _client
        .from('persons')
        .update({'spouse_id': personId})
        .eq('id', spouseId);
  }

  // ==========================================================
  // IMAGE UPLOAD (WEB + MOBILE SAFE)
  // ==========================================================

  /// Upload image using BYTES
  /// 🔴 Bucket must exist: avatars (PUBLIC)
  static Future<String> uploadImageBytes(
    Uint8List bytes, {
    String extension = 'png',
  }) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';

    await _client.storage
        .from('avatars')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(upsert: false, cacheControl: '3600'),
        );

    return _client.storage.from('avatars').getPublicUrl(fileName);
  }

  static Future<String> uploadImage(File file) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

    await _client.storage.from('avatars').upload(fileName, file);

    return _client.storage.from('avatars').getPublicUrl(fileName);
  }

  /// UPDATE MEMBER
  static Future<Person> updateMember(
    String id,
    Map<String, dynamic> data,
  ) async {
    final res = await _client
        .from('persons')
        .update(data)
        .eq('id', id)
        .select()
        .single();

    return Person.fromJson(res);
  }

  /// SAFE DELETE (SOFT DELETE)
  static Future<void> safeDeleteMember(String memberId) async {
    // 1️⃣ Check if member has children
    final children = await _client
        .from('persons')
        .select('id')
        .or('father_id.eq.$memberId,mother_id.eq.$memberId');

    if ((children as List).isNotEmpty) {
      throw 'Cannot delete member with children';
    }

    // 2️⃣ Auto-unlink spouse
    await _client
        .from('persons')
        .update({'spouse_id': null})
        .eq('spouse_id', memberId);

    // 3️⃣ Soft delete
    await _client
        .from('persons')
        .update({'is_deleted': true})
        .eq('id', memberId);
  }

  /// FORCE DELETE (ADMIN)
  static Future<void> forceDeleteMember(String memberId) async {
    // 1️⃣ Remove parent reference from children
    await _client
        .from('persons')
        .update({'father_id': null, 'mother_id': null})
        .or(
          'father_id.eq.$memberId,'
          'mother_id.eq.$memberId',
        );

    // 2️⃣ Unlink spouse
    await _client
        .from('persons')
        .update({'spouse_id': null})
        .eq('spouse_id', memberId);

    // 3️⃣ Soft delete member
    await _client
        .from('persons')
        .update({'is_deleted': true})
        .eq('id', memberId);
  }
}
