import 'package:flutter/material.dart';
import 'package:loreg/controller/user_controller.dart';
import 'package:loreg/repository/user_repository.dart';
import '../models/user.dart';



class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {



  @override
  Widget build(BuildContext context) {
    var userController = UserController(UserRepository());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste Utilisateurs'),
      ),
      body: Center(
        child: FutureBuilder<List<UserModel>>(
          future: userController.fetchUserList(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return ListTile(
                  leading: Text(user.userId, style: const TextStyle(color: Colors.blueGrey),),
                  title: Text(user.username),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              // alertModify(context, user.userId, user.username, user.email);
                            });
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.lightBlue,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _showDeleteModal(context, user.userId);
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index){
                return const Divider(
                  thickness:0.5,
                  height:0.5,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // alertCreate(context);
          });
        },

        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }


  _showDeleteModal(context, id) {
    var userController = UserController(UserRepository());

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (dialogContext) {
          return Container(
            // height: 800,
            height: 150,
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0, // has the effect of softening the shadow
                    spreadRadius: 0.0, // has the effect of extending the shadow
                  )
                ],
              ),
              alignment: Alignment.topLeft,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 5, left: 10),
                        child: const Text(
                          "Voulez-vous supprimer cet utilisateur ?",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 5, right: 5),
                          child: TextButton(

                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                            child: const Text(
                              "annuler",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff999999),
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Color(0xfff8f8f8),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            userController.deleteUser(id, () => {
                              setState((){})
                            });
                            Navigator.of(dialogContext).pop();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            fixedSize: const Size(200, 40),
                          ),
                          child: const Text('Supprimer'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
  
}