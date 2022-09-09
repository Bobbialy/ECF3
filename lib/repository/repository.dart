import 'package:loreg/models/user.dart';

abstract class Repository{
  Future<List<UserModel>> getUserList();
  Future<void> deleteUser(String id, cb);
  Future<void> registerUser(String name, String firstName, String email, String password, String status);
  Future<String> checkMail(email);
  Future<String> checkLogin(email, password);
}