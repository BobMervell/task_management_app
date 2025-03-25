import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:task_management_app/Widgets/task_summary_card.dart';
import 'package:task_management_app/Providers/task_provider.dart';


class ProjectCarousel extends StatefulWidget {
  final TaskProvider taskProvider;
  final double height;
  final double viewportFraction;
  const ProjectCarousel({
    super.key,
    required this.taskProvider,
    this.height = 300,
    this.viewportFraction = 0.4,
  });
  @override
  ProjectCarouselState createState() => ProjectCarouselState();
}

class ProjectCarouselState extends State<ProjectCarousel> {
  late CarouselOptions carouselOptions;
  
  
  @override
  void initState() {
    super.initState();
    carouselOptions = CarouselOptions(
      autoPlay: false,
      height: widget.height,
      autoPlayCurve: Curves.easeInBack,
      viewportFraction:widget.viewportFraction,
      enableInfiniteScroll: false,
      pageSnapping: false,
      scrollDirection: Axis.horizontal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: carouselOptions,
      items: widget.taskProvider.tasks.map((task) {
        return ProjectSummaryCard(
          task: task,
          onEdit: () {},
        );
      }).toList(),
    );
  }
}
