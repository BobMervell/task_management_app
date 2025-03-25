import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Widgets
import "package:task_management_app/Widgets/carousels.dart";

import 'package:task_management_app/Providers/tags_provider.dart';
import 'package:task_management_app/Themes/app_themes.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Providers/task_provider.dart';
import 'package:task_management_app/Models/task.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

// ignore: unused_import
import 'package:task_management_app/Widgets/test_widget.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => AvailableTags()),
      ],
      child: MyApp(),
    )
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      localizationsDelegates: [
        DefaultCupertinoLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        quill.FlutterQuillLocalizations.delegate, 
      ],
      title: 'Task Management',
      home: ProjectList(),
      );
  }
}

class ProjectList extends StatelessWidget {
  const ProjectList({super.key});

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);
      final List<Task> taskList = [
        Task(name: 'add procedural animation as addon with lots of text i mean very mmuch a lot of text ike its absur this amount of text my guy', accentColor: const Color.fromARGB(200, 244, 67, 54)),
        Task(name: 'begin devellop notion alternative with text', accentColor: const Color.fromARGB(200, 33, 150, 243)),
        Task(name: 'correct robot slight feet move with', accentColor: const Color.fromARGB(200, 76, 175, 80)),
        Task(name: 'mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm', accentColor: const Color.fromARGB(200, 255, 235, 59)),
        Task(name: 'ajout robot tilt', accentColor: const Color.fromARGB(200, 156, 39, 176)),
        Task(name: 'Task 6', accentColor: const Color.fromARGB(200, 255, 152, 0)),
        Task(name: 'Task 7', accentColor: const Color.fromARGB(200, 233, 30, 155)),
        Task(name: 'Task 8', accentColor: const Color.fromARGB(200, 0, 150, 136)),
        Task(name: 'Task 9', accentColor: const Color.fromARGB(200, 121, 85, 72)),
        Task(name: 'Task 10', accentColor: const Color.fromARGB(200, 63, 81, 181)),
      ];

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: ProjectCarousel(taskProvider: taskProvider)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var newProject = Task(
            name: 'New Project ${taskProvider.tasks.length + 1}',
            accentColor: Colors.red.withAlpha(200),
            subTasksList: taskList
            );
          taskProvider.addTask(newProject);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

