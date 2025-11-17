import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_app/features/pets/models/pet.dart';
import 'package:supabase_app/features/pets/models/pet_owner.dart';

class PetRepository {
  final SupabaseClient _client;

  PetRepository(this._client);

  // ==================== Pet Operations ====================

  Future<List<Pet>> getAllPets() async {
    final response = await _client
        .from('pets')
        .select()
        .order('name', ascending: true);
    return (response as List).map((json) => Pet.fromJson(json)).toList();
  }

  Future<Pet?> getPetById(int id) async {
    final response = await _client
        .from('pets')
        .select()
        .eq('id', id)
        .maybeSingle();
    return response != null ? Pet.fromJson(response) : null;
  }

  Future<List<Pet>> getPetsByOwnerId(int ownerId) async {
    final response = await _client
        .from('pets')
        .select()
        .eq('owner_id', ownerId)
        .order('name', ascending: true);
    return (response as List).map((json) => Pet.fromJson(json)).toList();
  }

  Future<int> addPet(Pet pet) async {
    final response = await _client
        .from('pets')
        .insert(pet.toJson())
        .select()
        .single();
    return response['id'] as int;
  }

  Future<void> updatePet(Pet pet) async {
    await _client.from('pets').update(pet.toJson()).eq('id', pet.id!);
  }

  Future<void> deletePet(int id) async {
    await _client.from('pets').delete().eq('id', id);
  }

  Future<int> getPetCount() async {
    final response = await _client
        .from('pets')
        .select()
        .count(CountOption.exact);
    return response.count;
  }

  Future<int> getPetCountByOwnerId(int ownerId) async {
    final response = await _client
        .from('pets')
        .select()
        .eq('owner_id', ownerId)
        .count(CountOption.exact);
    return response.count;
  }

  // ==================== Combined Operations ====================

  Future<List<PetOwner>> getPetsWithOwners() async {
    final response = await _client.from('pet_owner_view').select();
    return (response as List).map((json) => PetOwner.fromJson(json)).toList();
  }

  // ==================== Storage Operations ====================

  /// Upload pet image to Supabase Storage
  /// Returns the path to the uploaded image
  Future<String> uploadPetImage(int petId, File imageFile) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileExtension = imageFile.path.split('.').last;
    final fileName = 'pet_${petId}_$timestamp.$fileExtension';
    final filePath = 'images/$fileName';

    // Upload to Supabase Storage 'pets' bucket
    await _client.storage
        .from('pets')
        .upload(
          filePath,
          imageFile,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

    return filePath;
  }

  /// Delete pet image from Supabase Storage
  Future<void> deletePetImage(String imagePath) async {
    try {
      await _client.storage.from('pets').remove([imagePath]);
    } catch (e) {
      // Ignore errors if file doesn't exist
      print('Error deleting image: $e');
    }
  }

  /// Get public URL for pet image
  String getPetImageUrl(String imagePath) {
    return _client.storage.from('pets').getPublicUrl(imagePath);
  }

  /// Update pet with image path
  Future<void> updatePetImage(int petId, String imagePath) async {
    await _client
        .from('pets')
        .update({'image_path': imagePath})
        .eq('id', petId);
  }

  /// Add pet with image
  Future<int> addPetWithImage(Pet pet, File? imageFile) async {
    // First, insert the pet
    final petId = await addPet(pet);

    // If image is provided, upload it and update the pet
    if (imageFile != null) {
      final imagePath = await uploadPetImage(petId, imageFile);
      await updatePetImage(petId, imagePath);
    }

    return petId;
  }

  /// Delete pet and its image
  Future<void> deletePetWithImage(int petId) async {
    // Get pet to retrieve image path
    final pet = await getPetById(petId);

    // Delete image if exists
    if (pet?.imagePath != null) {
      await deletePetImage(pet!.imagePath!);
    }

    // Delete pet record
    await deletePet(petId);
  }
}
