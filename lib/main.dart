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
      final List<Task> taskList = [
        Task(name: 'Task 1', accentColor: const Color.fromARGB(200, 244, 67, 54)),
        Task(name: 'Task 2', accentColor: const Color.fromARGB(200, 33, 150, 243)),
        Task(name: 'Task 3', accentColor: const Color.fromARGB(200, 76, 175, 80)),
        Task(name: 'Task 4', accentColor: const Color.fromARGB(200, 255, 235, 59)),
        Task(name: 'Task 5', accentColor: const Color.fromARGB(200, 156, 39, 176)),
        Task(name: 'Task 6', accentColor: const Color.fromARGB(200, 255, 152, 0)),
        Task(name: 'Task 7', accentColor: const Color.fromARGB(200, 233, 30, 155)),
        Task(name: 'Task 8', accentColor: const Color.fromARGB(200, 0, 150, 136)),
        Task(name: 'Task 9', accentColor: const Color.fromARGB(200, 121, 85, 72)),
        Task(name: 'Task 10', accentColor: const Color.fromARGB(200, 63, 81, 181)),
      ];

    return Scaffold(
      body: 
      CarouselTest(taskProvider: taskProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var newProject = Task(
            name: 'New Project ${taskProvider.tasks.length + 1}',
            accentColor: const Color.fromARGB(200, 244, 67, 54),
            subTasksList: taskList
            );
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

  const CarouselTest({
    super.key,
    required this.taskProvider,
  });

  @override
  Widget build(BuildContext context) {
    return carousel.CarouselSlider(
      options: carouselTestOptions,
      items: taskProvider.tasks.map((task) {
        return ProjectSummaryCard(
            task: task,
            onEdit: () {
              print("TO DO add edit logic");
            },
          );
      }).toList(),
    );
  }
}


