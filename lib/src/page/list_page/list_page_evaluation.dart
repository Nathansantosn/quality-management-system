import 'package:assessment_software_senai/src/modal/modal_forms_evaluation.dart';
import 'package:assessment_software_senai/src/models/new_evaluation.dart';
import 'package:assessment_software_senai/src/services/evaluation_service.dart';
import 'package:assessment_software_senai/src/utils/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListPageEvaluation extends StatefulWidget {
  final User user;

  const ListPageEvaluation({super.key, required this.user});

  @override
  State<ListPageEvaluation> createState() => _ListPageEvaluationState();
}

class _ListPageEvaluationState extends State<ListPageEvaluation> {
  final EvaluationService _evaluationService = EvaluationService();

  User get user => widget.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Avaliações'),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  FormsEvaluation(evaluation: evaluation),
                              backgroundColor: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0),
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            SnackBar snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'Deseja remover ${evaluation.note} ?',
                              ),
                              action: SnackBarAction(
                                label: 'Remover',
                                textColor: Colors.white,
                                onPressed: () {
                                  _evaluationService.deleteEvaluation(
                                    evaluation,
                                  );
                                },
                              ),
                            );
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(snackBar);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
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
