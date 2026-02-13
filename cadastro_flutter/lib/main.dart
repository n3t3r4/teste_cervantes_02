import 'package:cadastro_flutter/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(970, 1000),
    center: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste de Desenvolvimento',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Color.fromRGBO(183, 60, 26, 1)),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MyHomePage(title: 'Teste de Desenvolvimento'),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  var textController = TextEditingController();
  var numberController = TextEditingController();

  var crud = CrudMethods();

  List<Map<String, dynamic>> data = [];

  Future<void> loadData() async {
    var database = await OpenMyDatabase();
    data = await database.query('cadastro', orderBy: 'id DESC');
    // print(data);
    setState(() {});
  }

  void clearTextFields() {
    textController.clear();
    numberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(183, 60, 26, 1),
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 240, right: 240),
        child: Column(
          children: [
            // LOGO
            const Image(image: AssetImage('images/logo_cervantes.png')),

            // CAMPO TEXTO
            TextField(
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Campo Texto',
              ),
            ),

            // ESPAÇAMENTO
            const SizedBox(height: 15),

            // CAMPO NUMERICO
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Campo Númerico',
              ),
            ),

            // ESPAÇAMENTO
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ADICIONAR
                ElevatedButton(
                  onPressed: () async {
                    if (numberController.text.isEmpty) {
                      numberController.text = '0';
                    }
                    await crud.createRegister(
                      textController.text,
                      int.parse(numberController.text),
                    );
                    await loadData();
                    clearTextFields();
                  },
                  child: Text('Adicionar'),
                ),

                // ALTERAR
                ElevatedButton(
                  onPressed: () async {
                    if (numberController.text.isEmpty) {
                      numberController.text = '0';
                    }
                    await crud.updateRegister(
                      textController.text,
                      int.parse(numberController.text),
                    );
                    await loadData();
                    clearTextFields();
                  },
                  child: Text('Alterar'),
                ),

                // DELETAR
                ElevatedButton(
                  onPressed: () async {
                    if (numberController.text.isEmpty) {
                      numberController.text = '0';
                    }
                    await crud.deleteRegister(int.parse(numberController.text));
                    await loadData();
                    clearTextFields();
                  },
                  child: Text('Deletar'),
                ),

                // LIMPAR CAMPOS
                ElevatedButton(
                  onPressed: () async {
                    clearTextFields();
                    return;
                  },
                  child: Text('Limpar Campos'),
                ),
              ],
            ),

            // TITULO DA TABELA
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text('Registros', style: TextStyle(fontSize: 24)),
            ),

            // TABELA
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Texto")),
                    DataColumn(label: Text("Número")),
                  ],
                  rows: data.isEmpty
                      ? [
                          DataRow(
                            cells: [
                              DataCell(Text('-')),
                              DataCell(Text('Nenhum registro encontrado')),
                              DataCell(Text('-')),
                            ],
                          ),
                        ]
                      : List.generate(data.length, (i) {
                          var singleData = data[i];
                          return DataRow(
                            color: WidgetStateProperty.all(
                              i.isEven ? Colors.grey.shade50 : Colors.white,
                            ),

                            onSelectChanged: (_) {
                              setState(() {
                                textController.text = singleData['campo_texto'];
                                numberController.text =
                                    singleData['campo_numerico'].toString();
                              });
                            },
                            cells: [
                              DataCell(Text(singleData['id'].toString())),
                              DataCell(Text(singleData['campo_texto'])),
                              DataCell(
                                Text(singleData['campo_numerico'].toString()),
                              ),
                            ],
                          );
                        }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
