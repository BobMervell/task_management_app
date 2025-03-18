import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'Themes/app_themes.dart';
import 'package:provider/provider.dart';
import 'Providers/task_provider.dart';
import 'Models/task.dart';
import 'Widgets/task_summary_card.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;

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
          var newProject = Task(name: 'New Project ${taskProvider.tasks.length + 1}');
          taskProvider.addTask(newProject);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}




CarouselOptions carouselTestOptions = carousel.CarouselOptions(
          height: 200.0,
          aspectRatio: 16 / 9,
          autoPlay: false,
          autoPlayCurve: Curves.linear,
          viewportFraction: 0.15,
          enableInfiniteScroll: false
        );



class CarouselTest extends StatelessWidget {
  const CarouselTest({
    super.key,
    required this.taskProvider,
  });

  final TaskProvider taskProvider;

  @override
  Widget build(BuildContext context) {
    return carousel.CarouselSlider(
      options: carouselTestOptions,
      items: taskProvider.tasks.map((task) {
        return TaskSummaryCard(
            task: Task(name: "test"), 
            onEdit: () {
              //TO DO add edit logic
            },
          );
      }).toList(),
    );
  }
}


