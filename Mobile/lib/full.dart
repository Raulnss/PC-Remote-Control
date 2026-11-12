import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:app_mobile/save_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:udp/udp.dart';

class full extends StatefulWidget {
  @override
  State<full> createState() => fullState();
}

class fullState extends State<full> {
  String appId = "Carregando...";
  String appName = "";
  int nun = 0;
  CounterStorage storage = CounterStorage();
  List<Map<String, String>> allIds = []; 

  @override
  void initState() {
    super.initState();
    loadAllIds();
  }

  // Carrega todos os IDs existentes
  void loadAllIds() async {
    List<Map<String, String>> ids = await storage.readAllIds();
    if (ids.isEmpty) {
      Map<String, String> newEntry =
          await storage.generateIdIfNotExists(defaultName: "ID Principal");
      ids.add(newEntry);
    }
    setState(() {
      allIds = ids;
      appId = allIds.first["id"]!;
      appName = allIds.first["name"]!;
    });
  }

  // Adiciona novo código com nome
  void addNewCode() async {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rnd = Random();
    String newId =
        List.generate(10, (_) => chars[rnd.nextInt(chars.length)]).join();

    // Dialog para o usuário digitar o nome
    String? name = await showDialog<String>(
        context: context,
        builder: (context) {
          TextEditingController controller = TextEditingController();
          return AlertDialog(
            title: Text("Nome do ID"),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Ex: PC do escritório"),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: Text("Cancelar")),
              TextButton(
                  onPressed: () => Navigator.pop(context, controller.text),
                  child: Text("OK")),
            ],
          );
        });

    if (name == null || name.isEmpty) name = "ID Sem Nome";

    await storage.addNewId(newId, name);

    setState(() {
      allIds.add({"name": name!, "id": newId});
      appId = newId;
      appName = name;
    });
  }

  void deleteCode(String id, String name) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Deletar ID"),
        content: Text("Deseja realmente deletar o ID '$name'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Deletar")),
        ],
      ),
    );

    if (confirm == true) {
      await storage.deleteId(id);
      setState(() {
        allIds.removeWhere((element) => element["id"] == id);
        // Se o ID deletado era o selecionado, troca para outro
        if (appId == id && allIds.isNotEmpty) {
          appId = allIds.first["id"]!;
          appName = allIds.first["name"]!;
        } else if (allIds.isEmpty) {
          appId = "Carregando...";
          appName = "";
        }
      });
    }
  }

  // Envia a requisição para a API
  void mandar(String com_) async {
    http.Response response = await http.post(
      Uri.parse('URL'),
      body: {"cod": appId, "com": com_},
      headers: {
        'Accept': 'application/json',
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) print("Requisição enviada com sucesso!");
    } else {
      if (kDebugMode) print('Erro na requisição: ${response.statusCode}');
    }
  }

  // Timer para desligamento
  void chamar(int min, String c_) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Timer iniciado: desligando em $min minuto(s)"),
        backgroundColor: Colors.blue,
      ),
    );

    Timer(Duration(minutes: min), () {
      mandar(c_);
    });
  }

  Future<void> wakePc(String mac) async {
    final macBytes = mac
        .split(':')
        .map((e) => int.parse(e, radix: 16))
        .toList();

    final packet = <int>[];

    // 6 bytes FF
    packet.addAll(List.filled(6, 0xFF));

    // MAC repetido 16 vezes
    for (int i = 0; i < 16; i++) {
      packet.addAll(macBytes);
    }

    final sender = await UDP.bind(Endpoint.any());

    await sender.send(
      Uint8List.fromList(packet),
      Endpoint.unicast(
        InternetAddress("192.168.18.255"),
        port: Port(9),
      ),
    );

    sender.close();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aplicativo nada"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Text("Códigos disponíveis",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: allIds.length,
                itemBuilder: (context, index) {
                  String id = allIds[index]["id"]!;
                  String name = allIds[index]["name"]!;
                  return ListTile(
                    title: Text(name),
                    subtitle: Text(id),
                    selected: id == appId,
                    onTap: () {
                      setState(() {
                        appId = id;
                        appName = name;
                        Navigator.pop(context);
                      });
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteCode(id, name);
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: addNewCode,
                child: Text("Adicionar novo código"),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Nome do ID: $appName",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 5),
              Text("Código: $appId", style: TextStyle(color: Colors.white)),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  nun = int.tryParse(text) ?? 0;
                },
                decoration: InputDecoration(
                  labelText: "Timer para desligamento (minutos)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // butoes
              ElevatedButton(
                onPressed: () async {
                  try {
                    await wakePc("");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Magic Packet enviado"),
                      ),
                    );
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text("Ligar PC"),
              ),
              ElevatedButton(
                onPressed: () {
                  chamar(nun, "desligar");
                },
                child: Text("Desligar"),
              ),
              ElevatedButton(
                onPressed: () {
                  chamar(nun, "reiniciar");
                },
                child: Text("Reiniciar"),
              ),
              ElevatedButton(
                onPressed: () {
                  chamar(nun, "mais_volume");
                },
                child: Text("Aumentar o volume"),
              ),
              ElevatedButton(
                onPressed: () {
                  chamar(nun, "menos_volume");
                },
                child: Text("Diminuir o volume"),
              ),
              ElevatedButton(
                onPressed: () {
                  chamar(nun, "space");
                },
                child: Text("Espaço"),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}