import 'package:assessment_software_senai/src/modal/modal_forms_question.dart';
import 'package:assessment_software_senai/src/models/new_questio.dart';
import 'package:assessment_software_senai/src/services/question_service.dart';
import 'package:assessment_software_senai/src/utils/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListPageQuestion extends StatefulWidget {
  final User user;

  const ListPageQuestion({super.key, required this.user});

  @override
  State<ListPageQuestion> createState() => _ListPageQuestionState();
}

class _ListPageQuestionState extends State<ListPageQuestion> {
  final QuestionService _questionService = QuestionService();

  User get user => widget.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Questões'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(user: widget.user),
      body: StreamBuilder(
        stream: _questionService.conectStreamQuestion(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.docs.isNotEmpty) {
              List<Question> listaQuestions = [];

              for (var doc in snapshot.data!.docs) {
                listaQuestions.add(Question.fromMap(doc.data()));
              }
              return ListView(
                children: List.generate(listaQuestions.length, (index) {
                  Question question = listaQuestions[index];
                  return ListTile(
                    title: Text(question.name),
                    subtitle: Text(
                      'Descrição: ${question.description}\n'
                      'Sistema: ${question.systemId} \n'
                      'Criterio: ${question.criterionId}\n'
                      'SubCriterio: ${question.subCriterionId} \n',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  FormsQuestion(question: question),
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
                                'Deseja remover ${question.name} ?',
                              ),
                              action: SnackBarAction(
                                label: 'Remover',
                                textColor: Colors.white,
                                onPressed: () {
                                  _questionService.deleteQuestion(question);
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
