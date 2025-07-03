import 'package:assessment_software_senai/src/common/dropdown_decoration.dart';
import 'package:assessment_software_senai/src/common/get_authentication_input_decoration.dart';
import 'package:assessment_software_senai/src/models/new_questio.dart';
import 'package:assessment_software_senai/src/services/question_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FormsQuestion extends StatefulWidget {
  final Question? question;
  const FormsQuestion({super.key, this.question});

  @override
  State<FormsQuestion> createState() => _FormsQuestionState();
}

class _FormsQuestionState extends State<FormsQuestion> {
  final _formKey = GlobalKey<FormState>();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final currentUser = FirebaseAuth.instance.currentUser;
  final QuestionService _questionService = QuestionService();
  final TextEditingController _nameQuestionController = TextEditingController();
  final TextEditingController _descriptionQuestionController =
      TextEditingController();

  String? selectedSystemId;
  String? selectedCriterionId;
  String? selectedSubCriterionId;

  bool isLoading = false;

  List<QueryDocumentSnapshot>? _systems;
  List<QueryDocumentSnapshot>? _criterions;
  List<QueryDocumentSnapshot>? _subcriterions;

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

    if (widget.question != null) {
      _nameQuestionController.text = widget.question!.name;
      _descriptionQuestionController.text = widget.question!.description;
      selectedSystemId = widget.question!.systemId;
      selectedCriterionId = widget.question!.criterionId;
      selectedSubCriterionId = widget.question!.subCriterionId;
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (widget.question != null)
                    ? 'Editar Questão'
                    : 'Cadastre o Questão!',
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
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameQuestionController,
                  decoration: getAuthenticationInputDecoration(
                    'Nome',
                    icon: Icon(Icons.abc, color: Colors.white),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'O Nome não pode ser vazio';
                    } else {
                      //deu certo
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionQuestionController,
                  decoration: getAuthenticationInputDecoration(
                    'Descrição',
                    icon: Icon(Icons.abc, color: Colors.white),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'A descrição não pode ser vazio';
                    } else {
                      //deu certo
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
                      'Selecione o Sitema',
                      selectionColor: Colors.white,
                      style: TextStyle(color: Colors.black54),
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
                        _criterions = null;
                        _subcriterions = null;
                        isLoading = value != null;
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
                //criterion
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: CircularProgressIndicator(),
                  )
                else if (_criterions != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
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
                          _subcriterions = null;
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
                    (widget.question != null) ? 'Editar' : 'Cadastrar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }

  sendClicked() {
    setState(() {
      isLoading = true;
    });

    String name = _nameQuestionController.text;
    String description = _descriptionQuestionController.text;

    Question question = Question(
      id: const Uuid().v1(),
      name: name,
      description: description,
      systemId: selectedSystemId ?? 'Sem sistema',
      criterionId: selectedCriterionId ?? 'Sem Critério',
      subCriterionId: selectedSubCriterionId ?? 'Sem Subcritério',
    );

    if (widget.question != null) {
      question.id = widget.question!.id; // Mantém o ID se for edição
    }

    _questionService.registerQuestion(question).then((value) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    });
  }
}
