import 'package:assessment_software_senai/src/models/new_system.dart';
import 'package:assessment_software_senai/src/common/get_authentication_input_decoration.dart';
import 'package:assessment_software_senai/src/services/system_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FormsSystem extends StatefulWidget {
  final System? system;
  const FormsSystem({super.key, this.system});

  @override
  State<FormsSystem> createState() => _FormsSystemState();
}

class _FormsSystemState extends State<FormsSystem> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameSystemController = TextEditingController();

  bool isLoading = false;

  final SystemService _systemService = SystemService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.system != null) {
      _nameSystemController.text = widget.system!.name;
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
                (widget.system != null)
                    ? 'Editar Sistema'
                    : 'Cadastre o nome do sistema!',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameSystemController,
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
                    SizedBox(height: 150),
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
                    child: CircularProgressIndicator(color: Colors.blue),
                  )
                : Text((widget.system != null) ? 'Editar' : 'Cadastrar'),
          ),
        ],
      ),
    );
  }

  sendClicked() {
    setState(() {
      isLoading = true;
    });

    String name = _nameSystemController.text;

    System system = System(id: const Uuid().v1(), name: name);

    if (widget.system != null) {
      system.id = widget.system!.id;
    }

    _systemService.registerSystem(name: system.name, id: system.id).then((
      value,
    ) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    });
  }
}
