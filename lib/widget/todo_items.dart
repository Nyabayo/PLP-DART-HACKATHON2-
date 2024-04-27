import 'package:flutter/material.dart';
import 'package:task_tide/model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final Function(ToDo) onToDoChanged;
  final Function(String) onDeleteItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          bottom: 20), // Consistent use of const for immutables
      child: ListTile(
        onTap: () => onToDoChanged(todo),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.blue,
        ),
        title: Text(
          todo.todoText,
          style: TextStyle(
            fontSize: 16,
            color: Colors
                .black87, // Use more neutral text color for better readability
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Confirm Delete"),
                content:
                    const Text("Are you sure you want to delete this task?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      onDeleteItem(todo.id);
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Delete",
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(
              Icons.delete,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
