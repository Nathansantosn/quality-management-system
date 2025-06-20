import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FormsQuestion extends StatefulWidget {
  const FormsQuestion({super.key});

  @override
  State<FormsQuestion> createState() => _FormsQuestionState();
}

class _FormsQuestionState extends State<FormsQuestion> {
  final _formKey = GlobalKey<FormState>();
  final currentUser = FirebaseAuth.instance.currentUser;

  String? selectedSystemId;
  String? selectedCriterionId;
  String? selectedSubCriterionId;

  bool isLoading = false;
  bool _isCriteriaLoading = false;

  List<QueryDocumentSnapshot>? _systems;
  List<QueryDocumentSnapshot>? _criteria;

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cadastre o Questão!',
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
                //System
                if (_systems == null)
                  const CircularProgressIndicator()
                else
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedSystemId,
                    hint: const Text(
                      'Selecione o Sitema',
                      selectionColor: Colors.white,
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
                        _criteria = null;
                        _isCriteriaLoading = value != null;
                      });

                      if (value != null) {
                        final selectedSystemDoc = _systems!.firstWhere(
                          (doc) => doc.id == value,
                        );
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(selectedSystemDoc.reference.parent.parent!.id)
                            .collection('systems')
                            .doc(selectedSystemDoc.id)
                            .collection('criterions')
                            .get()
                            .then((snapshot) {
                              if (mounted) {
                                setState(() {
                                  _criteria = snapshot.docs;
                                  _isCriteriaLoading = false;
                                });
                              }
                            });
                      }
                    },
                  ),
                //critperio
                if (_isCriteriaLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: CircularProgressIndicator(),
                  )
                else if (selectedSystemId != null && _criteria != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedCriterionId,
                      hint: const Text('Selecione o Critério'),
                      items: _criteria!.map((doc) {
                        final name = doc['name'] ?? '';
                        final description = doc['description'] ?? '';
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text('$name \n $description'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCriterionId = value;
                          selectedSubCriterionId = null;
                        });
                      },
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
