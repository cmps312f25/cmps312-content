import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_app/features/pets/models/owner.dart';

class OwnerRepository {
  final SupabaseClient _client;

  OwnerRepository(this._client);

  Future<List<Owner>> getAllOwners() async {
    final response = await _client
        .from('owners')
        .select()
        .order('last_name', ascending: true)
        .order('first_name', ascending: true);
    return (response as List).map((json) => Owner.fromJson(json)).toList();
  }

  Future<Owner?> getOwnerById(int id) async {
    final response = await _client
        .from('owners')
        .select()
        .eq('id', id)
        .maybeSingle();
    return response != null ? Owner.fromJson(response) : null;
  }

  Future<int> addOwner(Owner owner) async {
    final response = await _client
        .from('owners')
        .insert(owner.toJson())
        .select()
        .single();
    return response['id'] as int;
  }

  Future<void> updateOwner(Owner owner) async {
    await _client.from('owners').update(owner.toJson()).eq('id', owner.id!);
  }

  Future<void> deleteOwner(int id) async {
    await _client.from('owners').delete().eq('id', id);
  }

  Future<int> getOwnerCount() async {
    final response = await _client
        .from('owners')
        .select()
        .count(CountOption.exact);
    return response.count;
  }
}
