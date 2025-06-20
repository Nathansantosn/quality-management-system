import 'package:assessment_software_senai/src/common/my_snackbar.dart';
import 'package:assessment_software_senai/src/modules/components/get_authentication_input_decoration.dart';
import 'package:assessment_software_senai/src/page/home/home_page.dart';
import 'package:assessment_software_senai/src/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool queroEntrar = true;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  final AuthenticationService _authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF2196F3)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 68.0, left: 22.0),
              child: Text(
                'Login\nAssessment Software',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Informa o email';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return 'Email invalido.';
                              }
                              return null;
                            },
                            decoration: getAuthenticationInputDecoration(
                              'Email',
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            validator: (String? value) {
                              if (value == null || value.length < 6) {
                                return 'Senha deve ter no minimo 6 caracteres';
                              }
                              return null;
                            },
                            decoration: getAuthenticationInputDecoration(
                              'Senha',
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 20),
                          Visibility(
                            visible: !queroEntrar,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  decoration: getAuthenticationInputDecoration(
                                    'Nome',
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'O Nome não pode ser vazio';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _positionController,
                                  decoration: getAuthenticationInputDecoration(
                                    'Cargo',
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'O Cargo não pode ser vazio';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 70),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                            ),
                            onPressed: () {
                              mainButtonClicked();
                            },
                            child: Text(
                              (queroEntrar) ? 'Entrar' : 'Cadastrar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(height: 70),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                queroEntrar = !queroEntrar;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  (queroEntrar)
                                      ? 'Não tem uma conta? Cadastre-se?'
                                      : 'Já tem uma conta? Entre!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  mainButtonClicked() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String position = _positionController.text;

    if (_formKey.currentState!.validate()) {
      if (queroEntrar) {
        print('Entrada Validada');
        String? erro = await _authenticationService.loginUser(
          email: email,
          password: password,
        );
        if (erro != null) {
          showSnackBar(context: context, texto: erro);
        } else {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HomePage(user: user);
                },
              ),
            );
          } else {
            showSnackBar(
              context: context,
              texto: "Erro: usuário não encontrado após login.",
            );
          }
        }
      } else {
        print('Cadastro Validado');
        print(
          '${_emailController.text},${_passwordController.text},${_nameController.text},${_positionController.text}},',
        );
        String? erro = await _authenticationService.registerUser(
          name: name,
          email: email,
          password: password,
          position: position,
        );
        //quando esse cadastro de usuario terminar vamos ver o que ele retornou ,then
        if (erro != null) {
          //voltou com erro
          showSnackBar(context: context, texto: erro);
        }
      }
    } else {
      print('Form inválido');
    }
  }
}



// final user = User(
//  name: _nameController.text.toString(),
//email: _emailController.text.toString(),
// password: _passwordController.text,
//cargo: _cargoController.text.toString(),
//);


