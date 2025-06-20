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
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('user')
                      .doc(currentUser!.uid)
                      .collection('systems')
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    final systems = snapshot.data!.docs;
                    return DropdownButtonFormField(
                      value: selectedSystemId,
                      hint: Text(
                        'Selecione o Sitema',
                        selectionColor: Colors.white,
                      ),
                      items: systems.map((doc) {
                        return DropdownMenuItem(
                          value: doc.id,
                          child: Text(doc['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSystemId = value;
                          selectedCriterionId = null;
                          selectedSubCriterionId = null;
                        });
                      },
                    );
                  },
                ),
                //critperio
                if (selectedSystemId != null)
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('user')
                        .doc(currentUser!.uid)
                        .collection('systems')
                        .doc(selectedSystemId)
                        .collection('criterions')
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      final criterion = snapshot.data!.docs;
                      return DropdownButtonFormField(
                        value: selectedCriterionId,
                        hint: Text('Selecione o Critério'),
                        items: criterion.map((doc) {
                          final name = doc['name'] ?? '';
                          final description = doc['description'] ?? '';
                          return DropdownMenuItem(
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
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
