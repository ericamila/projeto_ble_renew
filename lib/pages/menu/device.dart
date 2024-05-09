import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/pages/device_vinculate.dart';
import 'package:projeto_ble_renew/pages/forms/device.dart';
import '../../components/my_filled_button.dart';
import '../device_unvinculate.dart';
import '../list/list_device.dart';


class MenuDispositivo extends StatefulWidget {
  const MenuDispositivo({super.key});

  @override
  State<MenuDispositivo> createState() => _MenuDispositivoState();
}

class _MenuDispositivoState extends State<MenuDispositivo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 600.0,
          ),
          height: 400,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MyFlilledButton(
                  text: "Cadastrar",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FormCadastroDispositivo(
                              atualiza: '',
                            )));
                  }),
              MyFlilledButton(
                  text: "Listar",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ListarDispositivos()));
                  }),
              MyFlilledButton(
                  text: "Vincular",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VincularDispositivos()));
                  }),
              MyFlilledButton(
                  text: "Desvincular",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DesvincularDispositivos()));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
