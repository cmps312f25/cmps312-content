import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_app/app/providers/supabase_client_provider.dart';
import 'package:supabase_app/features/pets/repositories/owner_repository.dart';

final ownerRepositoryProvider = Provider<OwnerRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return OwnerRepository(client);
});
