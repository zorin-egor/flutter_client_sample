import 'package:flutterclientsample/domain/entities/models/user.dart';

abstract class UsersRepository {

  Future<List<User>> getUsers();

  Future<List<User>> getNextUsers();

  Future<bool> addUser(User item);

  Future<bool> removeUser(User item);

}