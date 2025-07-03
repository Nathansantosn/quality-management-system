import 'package:assessment_software_senai/src/modal/modal_forms_criterion.dart';
import 'package:assessment_software_senai/src/models/new_criterion.dart';
import 'package:assessment_software_senai/src/services/criteria_service.dart';
import 'package:assessment_software_senai/src/utils/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListPageCriterion extends StatefulWidget {
  final User user;

  const ListPageCriterion({super.key, required this.user});

  @override
  State<ListPageCriterion> createState() => _ListPageCriterionState();
}

class _ListPageCriterionState extends State<ListPageCriterion> {
  final CriterionService _criterionService = CriterionService();

  User get user => widget.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Criterios'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(user: widget.user),
      body: StreamBuilder(
        stream: _criterionService.conectStreamCriterion(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.docs.isNotEmpty) {
              List<Criterion> listaCriterion = [];

              for (var doc in snapshot.data!.docs) {
                listaCriterion.add(Criterion.fromMap(doc.data()));
              }
              return ListView(
                children: List.generate(listaCriterion.length, (index) {
                  Criterion criterion = listaCriterion[index];
                  return ListTile(
                    title: Text(criterion.name),
                    subtitle: Text(
                      'Id: ${criterion.id}\n'
                      'Descrição: ${criterion.description}\n'
                      'Usuário: ${widget.user.email}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  FormsCriterion(criterion: criterion),
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
                                'Deseja remover ${criterion.name} ?',
                              ),
                              action: SnackBarAction(
                                label: 'Remover',
                                textColor: Colors.white,
                                onPressed: () {
                                  _criterionService.deleteCriterion(
                                    criterioId: criterion.id,
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
                  'Nenhum criterio cadastrado.',
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
