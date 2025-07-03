import 'package:assessment_software_senai/src/modal/modal_forms_sub_criterion.dart';
import 'package:assessment_software_senai/src/models/new_criterion.dart';
import 'package:assessment_software_senai/src/common/get_authentication_input_decoration.dart';
import 'package:assessment_software_senai/src/services/criteria_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FormsCriterion extends StatefulWidget {
  final Criterion? criterion;
  const FormsCriterion({super.key, this.criterion});

  @override
  State<FormsCriterion> createState() => _FormsCriterionState();
}

class _FormsCriterionState extends State<FormsCriterion> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCriteriaController = TextEditingController();
  final TextEditingController _descriptionCriteriaController =
      TextEditingController();

  bool isLoading = false;

  final CriterionService _criteriaService = CriterionService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.criterion != null) {
      _nameCriteriaController.text = widget.criterion!.name;
      _descriptionCriteriaController.text = widget.criterion!.description;
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
                (widget.criterion != null)
                    ? 'Editar Criterio!'
                    : 'Cadastre o Criterio!',
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
                      controller: _nameCriteriaController,
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
                      controller: _descriptionCriteriaController,
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
                : Text((widget.criterion != null) ? 'Editar' : 'Cadastrar'),
          ),
        ],
      ),
    );
  }

  sendClicked() {
    setState(() {
      isLoading = true;
    });

    String name = _nameCriteriaController.text;
    String description = _descriptionCriteriaController.text;

    Criterion criterion = Criterion(
      id: const Uuid().v1(),
      name: name,
      description: description,
    );

    if (widget.criterion != null) {
      criterion.id = widget.criterion!.id;
    }

    _criteriaService
        .registerCriterion(
          id: criterion.id,
          name: criterion.name,
          description: criterion.description,
        )
        .then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context, criterion.id);
          showModalBottomSheet(
            context: context,
            builder: (context) => FormsSubCriterion(criterionId: criterion.id),
            backgroundColor: Colors.blue[700],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            isScrollControlled: true,
          );
        });
  }
}
