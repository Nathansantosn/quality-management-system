import 'package:assessment_software_senai/src/models/new_subcriterion.dart';
import 'package:assessment_software_senai/src/modules/components/get_authentication_input_decoration.dart';
import 'package:assessment_software_senai/src/services/sub_criteria_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FormsSubCriterion extends StatefulWidget {
  final String criterionId;

  const FormsSubCriterion({super.key, required this.criterionId});

  @override
  State<FormsSubCriterion> createState() => _FormsSubCriterionState();
}

class _FormsSubCriterionState extends State<FormsSubCriterion> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameSubCriteriaController =
      TextEditingController();
  final TextEditingController _descriptionSubCriteriaController =
      TextEditingController();

  bool isLoading = false;

  final SubCriterionService _criteriaService = SubCriterionService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      height: MediaQuery.of(context).size.height * 0.5,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Agora cadastre o SubCriterio!',
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
          SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameSubCriteriaController,
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
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionSubCriteriaController,
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
                    SizedBox(height: 70),
                  ],
                ),
              ),
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
                : const Text('Cadastrar'),
          ),
        ],
      ),
    );
  }

  sendClicked() {
    setState(() {
      isLoading = true;
    });

    String name = _nameSubCriteriaController.text;
    String description = _descriptionSubCriteriaController.text;

    SubCriterion subCriterion = SubCriterion(
      id: const Uuid().v1(),
      name: name,
      description: description,
    );

    _criteriaService
        .registerSubCriterion(
          criterionId: widget.criterionId,
          id: subCriterion.id,
          name: subCriterion.name,
          description: subCriterion.description,
        )
        .then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        });
  }
}
