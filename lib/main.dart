import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Widgets
import "package:task_management_app/Widgets/Components/carousels.dart";

import 'package:task_management_app/Providers/tags_provider.dart';
import 'package:task_management_app/Themes/app_themes.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Providers/task_provider.dart';
import 'package:task_management_app/Models/task.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:uuid/uuid.dart';

var uuid = Uuid();



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
      final List<Task> taskList = [];

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: ProjectCarousel(taskProvider: taskProvider,height: MediaQuery.of(context).size.height * 3/4)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var newProject = Task(
            name: '',
            accentColor: Colors.red.withAlpha(200),
            taskID: uuid.v4() ,
            parentTaskID: "null",
            subTasksList: taskList
            );
          taskProvider.addTask(newProject);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

