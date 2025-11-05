import 'package:floor/floor.dart';

@DatabaseView(
  'SELECT p.name as petName, o.name as ownerName FROM Pet p INNER JOIN Owner o on p.ownerId = o.id',
  viewName: 'PetWithOwnerView',
)
class PetOwner {
  final String petName;
  final String ownerName;
  PetOwner({required this.petName, required this.ownerName});
}
