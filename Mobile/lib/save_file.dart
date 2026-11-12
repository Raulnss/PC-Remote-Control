import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/appids.json'); // Agora é JSON
  }

  // Ler todos os IDs com nomes
  Future<List<Map<String, String>>> readAllIds() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      if (contents.isEmpty) return [];
      List<dynamic> jsonData = json.decode(contents);
      return jsonData.map((e) => Map<String, String>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Adicionar um novo ID com nome
  Future<File> addNewId(String id, String name) async {
    final file = await _localFile;
    List<Map<String, String>> ids = await readAllIds();
    ids.add({"name": name, "id": id});
    return file.writeAsString(json.encode(ids));
  }

  // Gerar um ID aleatório com nome default se não existir
  Future<Map<String, String>> generateIdIfNotExists(
      {String defaultName = "ID Sem Nome"}) async {
    List<Map<String, String>> ids = await readAllIds();
    if (ids.isNotEmpty) {
      // Retorna o primeiro ID existente
      return ids.first;
    }

    const chars =
        'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz0123456789';
    final rnd = Random();
    String newId =
        List.generate(10, (_) => chars[rnd.nextInt(chars.length)]).join();

    Map<String, String> newEntry = {"name": defaultName, "id": newId};
    await addNewId(newId, defaultName);
    return newEntry;
  }

  // Deletar um ID específico
  Future<File> deleteId(String id) async {
    final file = await _localFile;
    List<Map<String, String>> ids = await readAllIds();
    ids.removeWhere((element) => element["id"] == id);
    return file.writeAsString(json.encode(ids));
  }
}