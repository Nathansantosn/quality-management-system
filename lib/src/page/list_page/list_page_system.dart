import 'package:assessment_software_senai/src/modal/modal_forms_system.dart';
import 'package:assessment_software_senai/src/models/new_system.dart';
import 'package:assessment_software_senai/src/services/system_service.dart';
import 'package:assessment_software_senai/src/utils/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListPageSystem extends StatefulWidget {
  final User user;

  const ListPageSystem({super.key, required this.user});

  @override
  State<ListPageSystem> createState() => _ListPageSystemState();
}

class _ListPageSystemState extends State<ListPageSystem> {
  final SystemService _systemService = SystemService();

  User get user => widget.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Sistemas'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(user: widget.user),
      body: StreamBuilder(
        stream: _systemService.conectStreamSystem(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.docs.isNotEmpty) {
              List<System> listaSystems = [];

              for (var doc in snapshot.data!.docs) {
                listaSystems.add(System.fromMap(doc.data()));
              }
              return ListView(
                children: List.generate(listaSystems.length, (index) {
                  System system = listaSystems[index];
                  return ListTile(
                    title: Text(system.name),
                    subtitle: Text('id :${system.id}\n'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => FormsSystem(system: system),
                              backgroundColor: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
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
                              content: Text('Deseja remover ${system.name} ?'),
                              action: SnackBarAction(
                                label: 'Remover',
                                textColor: Colors.white,
                                onPressed: () {
                                  _systemService.deleteSystem(
                                    systemId: system.id,
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
                  'Nenhum sistema cadastado',
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
