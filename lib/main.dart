import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:task_management_app/db_helper.dart';


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
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider(dbHelper: dbHelper)),
        ChangeNotifierProvider(create: (context) => AvailableTags()),
      ],
      child: MyApp(dbHelper: dbHelper),
    )
  );
}



class MyApp extends StatelessWidget {
  final DatabaseHelper dbHelper;
  const MyApp({
    super.key,
    required this.dbHelper}
    );

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
      home: ProjectList(dbHelper: dbHelper),
      );
  }
}

class ProjectList extends StatelessWidget {
  final DatabaseHelper dbHelper;
  const ProjectList({
    super.key,
    required this.dbHelper}
    );

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);
      final List<String> taskList = [];

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: 
            ProjectCarousel(
              taskProvider: taskProvider,
              height: MediaQuery.of(context).size.height * 3/4,
              dbHelper: dbHelper
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var newProject = Task(
            name: '',
            accentColor: Colors.red.withAlpha(200),
            taskID: uuid.v4() ,
            parentTaskID: "null",
            subTasksList: taskList,
            dbHelper: dbHelper,
            );
          taskProvider.addTask(newProject);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

