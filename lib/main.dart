import 'package:flutter/material.dart';
import 'Themes/app_themes.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    
    
    return MaterialApp(
      home: const ProjectPage(),
      theme: lightTheme

      );
  }
}

class ProjectPage extends StatelessWidget{
  const ProjectPage({super.key});
   @override
  Widget build(BuildContext context) {
    String text = '';
    if (Theme.of(context).platform == TargetPlatform.windows){
      text ='destoooop';
    }
    else if (Theme.of(context).platform == TargetPlatform.android){
      text ='phooone';
    }
    return Scaffold(
        body: Center(
          child:
            Text(
              text,
              style: Theme.of(context).textTheme.headlineLarge,
              ),
        ),
      );
  }
}