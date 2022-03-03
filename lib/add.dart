import 'package:bigdata/model/db.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  @override
  Widget build(BuildContext context) {
    TextEditingController precioTotal = TextEditingController();
    String supermercado = '';

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Añadir ticket'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        //  borderRadius: BorderRadius.circular(8),
                        ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null,
                  hint: supermercado.isEmpty
                      ? const Text('Selecciona Supermercado')
                      : Text(supermercado),
                  value: supermercado,
                  items: List.generate(
                      Datos().supermercados.length,
                      (index) => DropdownMenuItem(
                          value: Datos().supermercados.elementAt(index),
                          child: Text(Datos().supermercados.elementAt(index)))),
                  onChanged: (supermercado) => supermercado = supermercado)
            ],
          ),
        ));
  }
}
