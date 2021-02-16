import 'dart:convert';

import 'package:notasdiarias_app/anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const _tabelaAnotacoes = "tabela_anotacoes";

class DAO {
  static final DAO _dao = DAO._internal();
  Database _database;

  factory DAO() {
    print(" -> DAO");
    return _dao;
  }

  DAO._internal() {
    if (_database == null) {
      _getDAO();
    }
    print(" -> Internal");
  }

  Future<Database> _getDAO() async {
    final databasePath = await getDatabasesPath();
    final databaseFile = join(databasePath, "database.db");

    _database =
        await openDatabase(databaseFile, version: 2, onCreate: (db, dbVersion) {
      String sql =
          "CREATE TABLE $_tabelaAnotacoes (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao VARCHAR, data DATETIME)";
      db.execute(sql);
    });

    return _database;
  }

  salvarAnotacao(Anotacao anotacao) async {

    _database.insert(_tabelaAnotacoes, Anotacao.toMap(anotacao));

    print("Informação salva no banco de dados");
  }

  Future<List<Map<String, dynamic>>> recuperarAnotacoes() async {
    try {
      Database database = await _getDAO();
      String sql = "SELECT * FROM $_tabelaAnotacoes ORDER BY data DESC";

      return database.rawQuery(sql);
    } catch (e) {
      return null;
    }
  }

  atualizarAnotacao(Anotacao anotacao) async{
      return await _database.update(
          _tabelaAnotacoes,
          Anotacao.toMap(anotacao),
         where: "id = ?",
        whereArgs: [anotacao.id],
      );
  }

  deletarAnotacao(int id) async {
    ///TO DO
    await _database.delete(
      _tabelaAnotacoes,
      where: "id = ?",
      whereArgs: [id]


    );
  }
}
