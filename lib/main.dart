import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'Themes/app_themes.dart';
import 'package:provider/provider.dart';
import 'Providers/task_provider.dart';
import 'Models/task.dart';
import 'Widgets/task_summary_card.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
// ignore: unused_import
import 'Widgets/test_widget.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MyApp(),
    )
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      home: ProjectList(),
      
      theme: lightTheme

      );
  }
}

class ProjectList extends StatelessWidget {
  const ProjectList({super.key});

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      body: 
      CarouselTest(taskProvider: taskProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var newProject = Task(name: 'New Project ${taskProvider.tasks.length + 1}',accentColor: Colors.red);
          taskProvider.addTask(newProject);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}




CarouselOptions carouselTestOptions = carousel.CarouselOptions(
          height: 300.0,
          autoPlay: false,
          autoPlayCurve: Curves.easeInBack,
          viewportFraction: 0.3,
          enableInfiniteScroll: false,
          pageSnapping: false
        );



class CarouselTest extends StatelessWidget {

  final TaskProvider taskProvider;
  final List<Task> taskList = [
    Task(name: 'Task 1', accentColor: Colors.red),
    Task(name: 'Task 2', accentColor: Colors.blue),
    Task(name: 'Task 3', accentColor: Colors.green),
    Task(name: 'Task 4', accentColor: Colors.yellow),
    Task(name: 'Task 5', accentColor: Colors.purple),
    Task(name: 'Task 6', accentColor: Colors.orange),
    Task(name: 'Task 7', accentColor: Colors.pink),
    Task(name: 'Task 8', accentColor: Colors.teal),
    Task(name: 'Task 9', accentColor: Colors.brown),
    Task(name: 'Task 10', accentColor: Colors.indigo),
  ];

  CarouselTest({
    super.key,
    required this.taskProvider,
  });

  @override
  Widget build(BuildContext context) {
    return carousel.CarouselSlider(
      options: carouselTestOptions,
      items: taskProvider.tasks.map((task) {
        return ProjectSummaryCard(
            task: Task(name: "Project ",accentColor: Colors.blue,subTasksList: taskList), 
            onEdit: () {
              //TO DO add edit logic
            },
          );
      }).toList(),
    );
  }
}


