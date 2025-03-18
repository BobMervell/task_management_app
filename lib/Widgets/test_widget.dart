import 'package:flutter/material.dart';

class HealthyLifeChallengeCard extends StatelessWidget {
  const HealthyLifeChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Coins arrondis
      ),
      elevation: 2.0, // Ombre légère pour la profondeur
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Healthy Life Challenge',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '5 Tasks Remaining',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                buildTaskItem('Add a participation', true),
                buildTaskItem('Get a free payment plan', true),
                buildTaskItem('Business trip preparation', false),
                buildTaskItem('Drink 6 glasses of water a day', false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTaskItem(String task, bool isChecked) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {},
          activeColor: Colors.green,
        ),
        SizedBox(width: 8),
        Text(task),
      ],
    );
  }
}
