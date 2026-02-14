Aplicação desktop desenvolvida utilizando **Flutter** e banco de dados **SQLite**, com os seguintes requisitos:

- Cadastro com campo texto e campo numérico
- Validações feitas no banco de dados
- Registro automático de logs (INSERT, UPDATE, DELETE)
- Aplicação acessa apenas a tabela principal (`cadastro`)

Tecnologias Utilizadas:

- **Flutter**
- **SQLite**

Bibliotecas utilizadas:

- `sqflite_common`
- `window_manager`
- `path`

Programa utilizado para monitorar o banco de dados:

- DB Browser for SQLite

O **código fonte** do projeto está dentro da pasta **`cadastro_flutter`**.

Todas as querys para a criaçao do banco de dados estão disponíveis no arquivo `database.sql`.

O banco de dados possui:

- Tabela **`cadastro`** onde estão os dados principais da aplicação;
- Tabela **`log_operacoes`** onde estão os registros automáticos de alterações;

O **executável** do projeto está dentro da pasta **`build`**.

Basta rodar o executável que a aplicação que irá `criar o database automaticamente`.

**Documentações Utilizadas**

`SQLite`

https://www.sqlitetutorial.net/sqlite-check-constraint/

https://www.sqlitetutorial.net/sqlite-trigger/

https://sqlitebrowser.org/

https://www.sqlite.org/rescode.html

`Flutter / Dart`

https://api.flutter.dev/flutter/widgets/

https://api.flutter.dev/flutter/dart-async/Future-class.html

https://api.flutter.dev/flutter/package-path_path/join.html

https://pub.dev/documentation/sqflite_common/latest/sqflite/openDatabase.html

https://api.flutter.dev/flutter/material/showDialog.html

https://api.flutter.dev/flutter/material/AlertDialog-class.html

https://api.flutter.dev/flutter/material/ScaffoldMessenger-class.html

https://api.flutter.dev/flutter/material/TextField-class.html

https://api.flutter.dev/flutter/widgets/Padding-class.html

https://api.flutter.dev/flutter/widgets/ListView-class.html

https://api.flutter.dev/flutter/services/TextInputFormatter-class.html

https://pub.dev/packages/window_manager

https://docs.flutter.dev/platform-integration/windows/building
