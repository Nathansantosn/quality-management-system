import 'package:assessment_software_senai/src/common/dropdown_decoration.dart';
import 'package:assessment_software_senai/src/common/get_authentication_input_decoration.dart';
import 'package:assessment_software_senai/src/models/new_evaluation.dart';
import 'package:assessment_software_senai/src/services/evaluation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FormsEvaluation extends StatefulWidget {
  final Evaluation? evaluation;
  const FormsEvaluation({super.key, this.evaluation});

  @override
  State<FormsEvaluation> createState() => _FormsEvaluation();
}

class _FormsEvaluation extends State<FormsEvaluation> {
  final _formkey = GlobalKey<FormState>();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final currentUser = FirebaseAuth.instance.currentUser;
  final EvaluationService _evaluationService = EvaluationService();
  final TextEditingController _noteAvaluationController =
      TextEditingController();
  final TextEditingController _descriptionAvaluationController =
      TextEditingController();

  String? selectedSystemId;
  String? selectedCriterionId;
  String? selectedSubCriterionId;
  String? selectedQuestionId;

  bool isLoading = false;

  List<QueryDocumentSnapshot>? _systems;
  List<QueryDocumentSnapshot>? _criterions;
  List<QueryDocumentSnapshot>? _subcriterions;
  List<QueryDocumentSnapshot>? _questions;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collectionGroup('systems').get().then((
      snapshot,
    ) {
      if (mounted) {
        setState(() {
          _systems = snapshot.docs;
        });
      }
    });

    if (widget.evaluation != null) {
      _noteAvaluationController.text = widget.evaluation!.note;
      _descriptionAvaluationController.text = widget.evaluation!.description;
      selectedSystemId = widget.evaluation!.systemId;
      selectedCriterionId = widget.evaluation!.criterionId;
      selectedSubCriterionId = widget.evaluation!.subCriterionId;
      selectedQuestionId = widget.evaluation!.questionId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                (widget.evaluation != null)
                    ? 'Editar Avaliação'
                    : 'Cadastre a Avaliação!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: _noteAvaluationController,
                  decoration: getAuthenticationInputDecoration(
                    'Nota',
                    icon: const Icon(Icons.star, color: Colors.white),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'A nota não pode ser vazia';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionAvaluationController,
                  decoration: getAuthenticationInputDecoration(
                    'Descrição',
                    icon: Icon(Icons.abc, color: Colors.white),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'A descrição não pode ser vazia';
                    } else {
                      return null;
                    }
                  },
                  maxLines: null,
                ),
                const SizedBox(height: 30),
                //System
                if (_systems == null)
                  const CircularProgressIndicator()
                else
                  DropdownButtonFormField<String>(
                    decoration: dropdownDecoration(),
                    isExpanded: true,
                    value: selectedSystemId,
                    hint: const Text(
                      'Selecione o Sistema',
                      selectionColor: Colors.white,
                      style: TextStyle(color: Colors.black),
                    ),
                    items: _systems!.map((doc) {
                      return DropdownMenuItem<String>(
                        value: doc.id,
                        child: Text(doc['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSystemId = value;
                        selectedCriterionId = null;
                        selectedSubCriterionId = null;
                        selectedQuestionId = null;
                        _criterions = null;
                        _subcriterions = null;
                        _questions = null;
                        isLoading = true;
                      });
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('Criterions')
                          .get()
                          .then((snapshot) {
                            if (mounted) {
                              setState(() {
                                _criterions = snapshot.docs;
                                isLoading = false;
                              });
                            }
                          });
                    },
                  ),
                const SizedBox(height: 20),
                //Criterion
                if (_criterions != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: DropdownButtonFormField<String>(
                      decoration: dropdownDecoration(),
                      isExpanded: true,
                      value: selectedCriterionId,
                      hint: const Text('Selecione o Critério'),
                      items: _criterions!.map((doc) {
                        final name = doc['name'] ?? '';
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text('$name \n'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCriterionId = value;
                          selectedSubCriterionId = null;
                          selectedQuestionId = null;
                          _subcriterions = null;
                          _questions = null;
                          isLoading = true;
                        });
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .collection('Criterions')
                            .doc(value!)
                            .collection('Subcriterions')
                            .get()
                            .then((snapshot) {
                              if (mounted) {
                                setState(() {
                                  _subcriterions = snapshot.docs;
                                  isLoading = false;
                                });
                              }
                            });
                      },
                    ),
                  ),
                const SizedBox(height: 20),

                //Subcriterion
                if (_subcriterions != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: DropdownButtonFormField<String>(
                      decoration: dropdownDecoration(),
                      isExpanded: true,
                      value: selectedSubCriterionId,
                      hint: const Text('Selecione o Subcritério'),
                      items: _subcriterions!.map((doc) {
                        final name = doc['name'] ?? '';
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text('$name\n'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSubCriterionId = value;
                          selectedQuestionId = null;
                          _questions = null;
                          isLoading = true;
                        });
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .collection('Questions')
                            .get()
                            .then((snapshot) {
                              if (mounted) {
                                setState(() {
                                  _questions = snapshot.docs;
                                  isLoading = false;
                                });
                              }
                            });
                      },
                    ),
                  ),
                //question
                const SizedBox(height: 20),
                if (_questions != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: DropdownButtonFormField<String>(
                      decoration: dropdownDecoration(),
                      isExpanded: true,
                      value: selectedQuestionId,
                      hint: const Text('Selecione a Questão'),
                      items: _questions!.map((doc) {
                        final name = doc['name'] ?? '';
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text('$name\n'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedQuestionId = value;
                        });
                      },
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              sendClicked();
            },
            child: (isLoading)
                ? const SizedBox(
                    height: 16,
                    width: 50,
                    child: CircularProgressIndicator(color: Colors.blue),
                  )
                : Text(
                    (widget.evaluation != null) ? 'Atualizar' : 'Cadastrar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }

  sendClicked() {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String note = _noteAvaluationController.text;
      String description = _descriptionAvaluationController.text;

      Evaluation evaluation = Evaluation(
        id: const Uuid().v1(),
        note: note,
        description: description,
        systemId: selectedSystemId ?? 'Sem Sistema',
        criterionId: selectedCriterionId ?? 'Sem Critérion',
        subCriterionId: selectedSubCriterionId ?? 'Sem Subcritérion',
        questionId: selectedQuestionId ?? 'Sem Questões',
      );

      if (widget.evaluation != null) {
        evaluation.id = widget.evaluation!.id;
      }

      _evaluationService.registerEvaluation(evaluation).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      });
    } else {
      print('Formulário inválido!');
    }
  }
}
