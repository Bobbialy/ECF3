import 'package:flutter/material.dart';
import 'package:loreg/bdd/mysql.dart';
import '../models/user_login.dart';
import '../screens/login.dart';
import 'package:loreg/controller/user_controller.dart';
import 'package:loreg/repository/user_repository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final  _formRegKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  String email = '';
  String password = '';
  String confirmPassword = '';
  String name = '';
  String firstName = '';

  LoginUser userInfo = LoginUser(passLog: '', mailLog: '');


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Inscription'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
          SingleChildScrollView(
            child:
              Form(
                  key: _formRegKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: const Center(
                          child: Text(
                              'Veuillez remplir les champs',
                              style: TextStyle(color: Colors.blueGrey)
                          ),
                        ),
                      ),

                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(right: 10),
                              width: MediaQuery.of(context).size.width / 2.1,
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: "Nom"),
                                validator: FormValidator.validateName,
                                onSaved: (value) {
                                  name = value!.trim();
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 10),
                              width: MediaQuery.of(context).size.width / 2.1,
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: "Prénom"),
                                validator: FormValidator.validateFirstName,
                                onSaved: (value) {
                                  firstName = value!.trim();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Email"),
                        validator: FormValidator.validateEmail,
                        onSaved: (value) {
                          email = value!.trim();
                          userInfo.mailLog = email;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Mot de passe"),
                        obscureText: true,
                        controller: _pass,
                        validator: FormValidator.validatePassword,
                        onSaved: (value) {
                          password = value!.trim();
                          userInfo.passLog = password;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Confirmer mot de passe"),
                        obscureText: true,
                        controller: _confirmPass,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Veuillez confirmer votre mot de passe';
                          }
                          if (val != _pass.text) {
                            return 'Ne correspond pas au mot de passe renseigné';
                          }
                          return null;
                        },
                        onSaved: (value) {

                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: register,
                          child: const Text('S\'inscrire'),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 50),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                                'Retourner à la page de connexion',
                                style: TextStyle(color: Colors.blueGrey)
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginPage()),
                                  );
                                },
                                child: const Text('Connexion')
                            )
                          ],
                        ),
                      ),
                    ],
                  )
              ),
          ),
      ),
    );
  }

  register() async {
    var userController = UserController(UserRepository());
    final FormState? form = _formRegKey.currentState;


    if (!form!.validate()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Les données renseignées ne sont pas valides')));
      });
    } else {
      form.save();
    }

    String mailCheck = await userController.checkMail(email);
    if (mailCheck == '1') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cet email est déjà utilisé')));
      });
    } else {
      userController.registerUser(name, firstName, email, password, 'user');
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
    if (value.length < 8) return 'Le mot de passe doit contenir au moins 8 caractères';
    Pattern oneMin = r'(?=.*[a-z])';
    Pattern oneMaj = r'(?=.*[A-Z])';
    Pattern oneNum = r'(?=.*[0-9])';

    RegExp regExpMin = RegExp(oneMin.toString());
    RegExp regExpMaj = RegExp(oneMaj.toString());
    RegExp regExpNum = RegExp(oneNum.toString());

    if (!regExpMin.hasMatch(value)) {
      return "Le mot de passe doit contenir au moins une minuscule";
    } else if (!regExpMaj.hasMatch(value)) {
      return "Le mot de passe doit contenir au moins une majuscule";
    } else if (!regExpNum.hasMatch(value)) {
      return "Le mot de passe doit contenir au moins un chiffre";
    }
    return null;
  }



  static String? validateName(String? value) {
    if (value!.isEmpty) return 'Le champ Nom est vide';
    Pattern pattern =
        r'^[a-zA-Z]+$';
    RegExp regExp = RegExp(pattern.toString());
    if (!regExp.hasMatch(value) || value.length < 2) {
      return "Nom invalide";
    }
    return null;
  }

  static String? validateFirstName(String? value) {
    if (value!.isEmpty) return 'Le champ Prénom est vide';
    Pattern pattern =
        r'^[a-zA-Z]+$';
    RegExp regExp = RegExp(pattern.toString());
    if (!regExp.hasMatch(value) || value.length < 2) {
      return "Prénom invalide";
    }
    return null;
  }
}