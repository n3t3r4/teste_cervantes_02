import 'dart:io' as io;
import 'package:cadastro_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';

void showAlert(String text) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (_) => AlertDialog(
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(navigatorKey.currentContext!);
          },
          child: Text("OK"),
        ),
      ],
    ),
  );
}

void showToast(String text) {
  ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(seconds: 1),
      backgroundColor: Color.fromRGBO(183, 60, 26, 1),
    ),
  );
}

Future OpenMyDatabase() async {
  sqfliteFfiInit();

  var databaseFactory = databaseFactoryFfi;
  final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();

  String databasePath = p.join(
    appDocumentsDir.path,
    'databases',
    'cervantes02.db',
  );

  var db = await databaseFactory.openDatabase(
    databasePath,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE IF NOT EXISTS Cadastro (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        campo_texto TEXT NOT NULL CHECK (trim(campo_texto) <> ''),
        campo_numerico INTEGER NOT NULL UNIQUE CHECK (campo_numerico > 0)
        )     
      ''');

        await db.execute('''
      CREATE TABLE IF NOT EXISTS Log_operacoes (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       operacao TEXT NOT NULL,
       data_hora TEXT DEFAUL CURRENT_TIMESTAMP
      )
''');

        await db.execute('''
      CREATE TRIGGER IF NOT EXISTS log_insert 
      AFTER INSERT ON cadastro
      BEGIN
        INSERT INTO Log_operacoes (operacao, data_hora)
        VALUES ('INSERT', CURRENT_TIMESTAMP);
      END;
''');

        await db.execute('''
      CREATE TRIGGER IF NOT EXISTS log_update 
      AFTER UPDATE ON cadastro
      BEGIN
        INSERT INTO Log_operacoes (operacao, data_hora)
        VALUES ('UPDATE', CURRENT_TIMESTAMP);
      END;
''');

        await db.execute('''
      CREATE TRIGGER IF NOT EXISTS log_delete 
      AFTER DELETE ON cadastro
      BEGIN
        INSERT INTO Log_operacoes (operacao, data_hora)
        VALUES ('DELETE', CURRENT_TIMESTAMP);
      END;
''');
        showAlert(
          "Database criado e querys executadas com sucesso." +
              "\n\n Database criado em " +
              databasePath,
        );
      },
    ),
  );

  return db;
}

class CrudMethods {
  Future<void> createRegister(String texto, int numero) async {
    try {
      var database = await OpenMyDatabase();

      await database.insert('cadastro', {
        'campo_texto': texto,
        'campo_numerico': numero,
      });
      showToast("Registro Inserido");
    } on DatabaseException catch (error) {
      // print(error.getResultCode());
      if (error.getResultCode() == 275) {
        showAlert("Erro! \n\n Valores inválidos");
      } else if (error.isUniqueConstraintError()) {
        showAlert("Erro! \n\n Registro Duplicado");
      }
    }
  }

  Future<void> deleteRegister(int numero) async {
    var database = await OpenMyDatabase();

    int result = await database.delete(
      'cadastro',
      where: 'campo_numerico = $numero',
    );
    if (result == 0) {
      showAlert("Erro! \n\n Nenhum registro encontrado");
    } else {
      showToast("Registro Deletado");
    }
  }

  Future<void> updateRegister(String texto, int numero) async {
    var database = await OpenMyDatabase();

    int result = await database.update('cadastro', {
      'campo_texto': texto,
      'campo_numerico': numero,
    }, where: 'campo_numerico = $numero');
    if (result == 0) {
      showAlert("Erro! \n\n Nenhum registro afetado");
    } else {
      showToast("Registro Modificado");
    }
  }
}
