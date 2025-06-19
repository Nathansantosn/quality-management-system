import 'package:assessment_software_senai/src/common/my_buldButton.dart';
import 'package:assessment_software_senai/src/modal/modal_forms_criterion.dart';
import 'package:assessment_software_senai/src/modal/modal_forms_question.dart';
import 'package:assessment_software_senai/src/modal/modal_forms_sub_criterion.dart';
import 'package:assessment_software_senai/src/modal/modal_forms_system.dart';
import 'package:assessment_software_senai/src/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MENU')),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                (widget.user.displayName != null)
                    ? widget.user.displayName!
                    : '',
              ),
              accountEmail: Text(widget.user.email!),
              decoration: BoxDecoration(color: Colors.blue[700]),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Deslogar'),
              onTap: () {
                AuthenticationService().unlog();
              },
            ),
          ],
        ),
      ),
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
              padding: const EdgeInsets.only(top: 15.0, left: 50.0),
              child: Text(
                'Assessment Software',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButton(
                  texto: 'Cadastrar sistema',
                  onCliked: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => FormsSystem(),
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    isScrollControlled: true,
                  ),
                ),
                SizedBox(height: 40),

                buildButton(
                  texto: 'Critério/SubCritério',
                  onCliked: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => FormsCriterion(),
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    isScrollControlled: true,
                  ),
                ),
                SizedBox(height: 40),
                buildButton(
                  texto: 'Avaliação',
                  onCliked: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => FormsQuestion(),
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    isScrollControlled: true,
                  ),
                ),
                SizedBox(height: 40),
                buildButton(
                  texto: 'Nota',
                  onCliked: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => FormsSystem(),
                  ),
                ),
                SizedBox(height: 40),
                buildButton(
                  texto: 'Listar',
                  onCliked: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => FormsSystem(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
