import '../repository/repository.dart';
import '../models/user.dart';

class UserController{
  final Repository _repository;
  UserController(this._repository);


  Future<List<UserModel>> fetchUserList() async{
    return _repository.getUserList();
  }

  Future<void> deleteUser(String id, cb) async{
    return _repository.deleteUser(id, cb);
  }

  Future<void> registerUser(String name, String firstName, String email, String password, String status) async{
    return _repository.registerUser(name, firstName, email, password, status);
  }

  Future<String> checkMail(String email) async{
    return _repository.checkMail(email);
  }

  Future<String> checkLogin(String email, String password) async {
    return _repository.checkLogin(email, password);
  }
}