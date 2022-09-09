import '../models/user.dart';
import '../repository/repository.dart';
import '../bdd/mysql.dart';


final db = Mysql();

class UserRepository implements Repository {


  @override
  Future<List<UserModel>> getUserList() async{

    String sql = 'select * from cryo.user_;';
    final List<UserModel> mylist = [];
    await db.getConnection().then((conn) async {
      await conn.query(sql).then((results) {
        for (var res in results) {

          final UserModel myuser = UserModel(
              userId: res['id_user'].toString(),
              username: res['nom_user'].toString(),
              email: res['login_user'].toString());

          mylist.add(myuser);
        }
      }).onError((error, stackTrace) {
        print(error);
        return null;
      });
      conn.close();
    });
    return mylist;
  }


  @override
  Future<void> deleteUser(id, cb) async{

    await db.getConnection().then((conn) async {
      await conn.query('Delete from cryo.user_ where id_user=?', [id]);
      conn.close();
      cb();
    }).onError((error, stackTrace) {
      print(error);
      return null;
    });
  }

  @override
  Future<void> registerUser(name, firstName, email, password, status) async {

    await db.getConnection().then((conn) async {
      await conn.query('INSERT INTO cryo.user_ (nom_user, prenom_user, login_user, password_user) values (?, ?, ?, sha2(?, 256))', [name, firstName, email, password]);
      conn.close();
    }).onError((error, stackTrace) {
      print(error);
      return null;
    });
  }


  @override
  Future<String> checkMail(email) async {
    print(email);
    String test = '';
    String sql = 'SELECT count(login_user) AS mail FROM cryo.user_ WHERE login_user = ?';

    await db.getConnection().then((conn) async {
      await conn.query(sql, [email]).then((result) {
        for (var res in result) {
          test = res['mail'].toString();
          print(test);
        }
      }).onError((error, stackTrace) {
        print(error);
        return null;
      });
      conn.close();
    });
    return test;
  }

  @override
  Future<String> checkLogin(email, password) async {
    String test = '';
    String sql = 'SELECT count(login_user) AS mail FROM cryo.user_ WHERE login_user = ? AND password_user = sha2(?, 256)';

    await db.getConnection().then((conn) async {
      await conn.query(sql, [email, password]).then((result) {
        for (var res in result) {
          test = res['mail'].toString();
        }
      }).onError((error, stackTrace) {
        print(error);
        return null;
      });
      conn.close();
    });
    return test;
  }
}