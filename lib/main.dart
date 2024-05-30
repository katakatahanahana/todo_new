import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, String>> entries = [];
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedTitle = '大学';
  String _selectedCategory = '全部';

  // プラスボタンを押したときに呼ばれる関数
  void addItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // use StatefulBuilder to ensure the dropdown updates within the dialog
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('タスクを追加'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton<String>(
                    value: _selectedTitle,
                    items: <String>['大学', '課題', 'サークル'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        _selectedTitle = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '内容',
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('キャンセル'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('追加'),
                  onPressed: () {
                    setState(() {
                      entries.add({
                        'title': _selectedTitle,
                        'description': _descriptionController.text,
                      });
                    });
                    _descriptionController.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = _selectedCategory == '全部'
        ? entries
        : entries
            .where((entry) => entry['title'] == _selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: DropdownButton<String>(
          value: _selectedCategory,
          items: <String>['全部', '大学', '課題', 'サークル'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue!;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addItem,
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: filteredEntries.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              filteredEntries[index]['title']!,
              textAlign: TextAlign.left,
            ),
            subtitle: Text(
              filteredEntries[index]['description']!,
              textAlign: TextAlign.left,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  entries.removeAt(entries.indexOf(filteredEntries[index]));
                });
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
