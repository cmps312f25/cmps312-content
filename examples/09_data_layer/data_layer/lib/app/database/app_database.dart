import 'dart:async';
import 'package:floor/floor.dart';
import 'package:data_layer/features/todos/models/todo.dart';
import 'package:data_layer/features/todos/daos/todo_dao.dart';
import 'package:data_layer/features/pets/models/owner.dart';
import 'package:data_layer/features/pets/models/pet.dart';
import 'package:data_layer/features/pets/models/pet_owner.dart';
import 'package:data_layer/features/pets/daos/owner_dao.dart';
import 'package:data_layer/features/pets/daos/pet_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart'; // Generated file

@Database(version: 1, entities: [Todo, Owner, Pet], views: [PetOwner])
abstract class AppDatabase extends FloorDatabase {
  TodoDao get todoDao;
  OwnerDao get ownerDao;
  PetDao get petDao;
}
