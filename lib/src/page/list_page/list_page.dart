import 'package:assessment_software_senai/src/models/new_evaluation.dart';
import 'package:assessment_software_senai/src/page/home/home_page.dart';
import 'package:assessment_software_senai/src/services/evaluation_service.dart';
import 'package:assessment_software_senai/src/utils/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  final User user;

  const ListPage({super.key, required this.user});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final EvaluationService _evaluationService = EvaluationService();
  bool _isLoading = false;

  User get user => widget.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(user: widget.user),
      body: StreamBuilder(
        stream: _evaluationService.conectStreamEvaluation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.docs.isNotEmpty) {
              List<Evaluation> listaEvaluations = [];

              for (var doc in snapshot.data!.docs) {
                listaEvaluations.add(Evaluation.fromMap(doc.data()));
              }
              return ListView(
                children: List.generate(listaEvaluations.length, (index) {
                  Evaluation evaluation = listaEvaluations[index];
                  return ListTile(
                    title: Text(evaluation.note),
                    subtitle: Text(
                      'Descrição: ${evaluation.description}\n'
                      'Sistema: ${evaluation.systemId} \n'
                      'Criterio: ${evaluation.criterionId}\n'
                      'SubCriterio: ${evaluation.subCriterionId} \n'
                      'Question: ${evaluation.questionId}',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(user: user),
                        ),
                      );
                    },
                  );
                }),
              );
            } else {
              return const Center(
                child: Text(
                  'Nenhuma avaliação cadastrada.',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
