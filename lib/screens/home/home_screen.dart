import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/dataservices/category.dart';
import 'package:todo/entities/category_entity.dart';
import 'package:todo/screens/todo/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedId;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Taipei.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.8),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              constraints: BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'TODO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${DateFormat('yyyy-MM-dd EEEE kk:mm').format(DateTime.now())}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: FutureBuilder<List<CategoryEntity>>(
              future: Category().getItems(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<CategoryEntity>> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('Loading...'),
                  );
                }
                return snapshot.data!.isEmpty
                    ? Center(
                        child: Text(
                          'No Category in List.',
                        ),
                      )
                    : MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView(
                          children: snapshot.data!.map(
                            (e) {
                              return Center(
                                child: Card(
                                  child: ListTile(
                                    title: Text(e.name),
                                    trailing: GestureDetector(
                                      child: Icon(Icons.edit),
                                      onTap: () {
                                        setState(() {
                                          textController.text = e.name;
                                          selectedId = e.id;
                                        });
                                      },
                                    ),
                                    onTap: () {
                                      setState(() {
                                        textController.clear();
                                        selectedId = null;
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TodoScreen(
                                              category: e,
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        Category().remove(e.id!);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      );
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            child: TextField(
              controller: textController,
              autofocus: false,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.add,
                ),
                hintText: 'Add category',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) async {
                if (selectedId != null) {
                  await Category().update(CategoryEntity(
                    id: selectedId,
                    name: value,
                  ));
                } else {
                  await Category().add(CategoryEntity(name: value));
                }
                setState(() {
                  textController.clear();
                  selectedId = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
