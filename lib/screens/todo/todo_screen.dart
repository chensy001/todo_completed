import 'package:flutter/material.dart';
import 'package:todo/dataservices/todo.dart';
import 'package:todo/entities/category_entity.dart';
import 'package:todo/entities/todo_entity.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key, required this.category}) : super(key: key);

  final CategoryEntity category;
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  int? selectedId;
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FutureBuilder<List<TodoEntity>>(
                future: Todo().getItems(widget.category.id!),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<TodoEntity>> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('Loading...'),
                    );
                  }
                  return snapshot.data!.isEmpty
                      ? Center(
                          child: Text(
                            'No Todo in List.',
                          ),
                        )
                      : ListView(
                          children: snapshot.data!.map(
                            (e) {
                              return Center(
                                child: Card(
                                  child: ListTile(
                                    title: Text(e.name),
                                    onTap: () {
                                      setState(() {
                                        if (selectedId == null) {
                                          textController.text = e.name;
                                          selectedId = e.id;
                                        } else {
                                          textController.text = '';
                                          selectedId = null;
                                        }
                                      });
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        Todo().remove(e.id!);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        );
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: 60,
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.add,
                  ),
                  hintText: 'Add todo',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (value) async {
                  if (selectedId != null) {
                    await Todo().update(TodoEntity(
                      id: selectedId,
                      category: widget.category.id!,
                      name: value,
                    ));
                  } else {
                    await Todo().add(TodoEntity(
                      category: widget.category.id!,
                      name: value,
                    ));
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
      ),
    );
  }
}
