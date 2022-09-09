import 'package:flutter/material.dart';
import 'package:loreg/bdd/mysql.dart';
import 'package:loreg/screens/register.dart';
import 'package:loreg/screens/accueil.dart';
import '../models/user_login.dart';
import 'package:loreg/controller/user_controller.dart';
import 'package:loreg/repository/user_repository.dart';
import '../screens/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  LoginUser test = LoginUser(passLog: '', mailLog: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Center(
                    child: Text('Connexion'),
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                  validator: FormValidator.validateEmail,
                  onSaved: (value) {
                    email = value!.trim();
                    test.mailLog = email;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Mot de passe"),
                  obscureText: true,
                  validator: FormValidator.validatePassword,
                  onSaved: (value) {
                    password = value!.trim();
                    test.passLog = password;
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      // Evite erreur avec context
                      final navigator = Navigator.of(context);
                      login(navigator);
                    },
                    child: const Text('Se connecter'),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 50),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Pas encore inscrit ?'),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterPage()),
                            );
                          },
                          child: const Text('Inscription')
                      )
                    ],
                  ),
                ),
              ],
            )
        ),
      ),

    );
  }




  login(nav) async {
    var userController = UserController(UserRepository());
    final FormState? form = _formKey.currentState;


    if (!form!.validate()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Les données renseignées ne sont pas valides')));
      });
      return;
    } else {
      form.save();
    }

    String mailCheck = await userController.checkMail(email);
    if (mailCheck == "0") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email incorrect')));
      });
    } else {
      String loginCheck = await userController.checkLogin(email, password);
      if (loginCheck == '0') {
        // Le mot de passe n'est pas bon
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mot de passe incorrect')));
        });
      } else {
        nav.push(MaterialPageRoute(builder: (context) => const MyResultPage()));
      }
    }
  }

}




class FormValidator {
  static String? validateEmail(String? email) {
    if (email!.isEmpty) return "Le champ email est vide";
    Pattern pattern =
        r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
    RegExp regExp = RegExp(pattern.toString());
    if (!regExp.hasMatch(email)) {
      return "Adresse mail invalide";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value!.isEmpty) return 'Le champ mot de passe est vide';

    return null;
  }
}