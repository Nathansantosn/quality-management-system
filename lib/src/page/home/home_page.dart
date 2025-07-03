import 'package:assessment_software_senai/src/common/my_buldButton.dart';
import 'package:assessment_software_senai/src/modal/modal_forms_criterion.dart';
import 'package:assessment_software_senai/src/modal/modal_forms_evaluation.dart';
import 'package:assessment_software_senai/src/modal/modal_forms_question.dart';
import 'package:assessment_software_senai/src/modal/modal_forms_system.dart';
import 'package:assessment_software_senai/src/models/new_criterion.dart';
import 'package:assessment_software_senai/src/page/list_page/list_page_criterion.dart';
import 'package:assessment_software_senai/src/page/list_page/list_page_evaluation.dart';
import 'package:assessment_software_senai/src/page/list_page/list_page_question.dart';
import 'package:assessment_software_senai/src/page/list_page/list_page_subcriterion.dart';
import 'package:assessment_software_senai/src/page/list_page/list_page_system.dart';
import 'package:assessment_software_senai/src/utils/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User user;
  final Criterion? criterion;
  const HomePage({super.key, required this.user, this.criterion});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MENU')),
      drawer: AppDrawer(user: widget.user),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
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
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ListPageSystem(user: widget.user),
                          ),
                        ),
                        icon: Icon(
                          Icons.list_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ListPageCriterion(user: widget.user),
                              ),
                            ),
                            icon: Icon(
                              Icons.list_alt,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListPageSubcriterion(
                                  user: widget.user,
                                  criterion: widget.criterion,
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.list_alt,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildButton(
                        texto: 'Questão',
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
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ListPageQuestion(user: widget.user),
                          ),
                        ),
                        icon: Icon(
                          Icons.list_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildButton(
                        texto: 'Avaliar/Nota',
                        onCliked: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => FormsEvaluation(),
                          backgroundColor: Colors.blue[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          isScrollControlled: true,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ListPageEvaluation(user: widget.user),
                          ),
                        ),
                        icon: Icon(
                          Icons.list_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
