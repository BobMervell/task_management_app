import 'package:flutter/foundation.dart';


class AvailableTags with ChangeNotifier {
  final List<String> _tags = [
  // Effort de la Tâche
  'Low Effort', 'Medium Effort', 'High Effort', 'Quick Task', 'Time-Consuming',
  'Easy', 'Moderate', 'Challenging', 'Simple', 'Complex',
  'Short Task', 'Long Task', 'Minor Effort', 'Major Effort', 'Instant Task',

  // Catégorie de Tâche
  'Work', 'Personal', 'Home', 'Shopping', 'Errands',
  'Meeting', 'Call', 'Email', 'Project', 'Study',
  'Exercise', 'Health', 'Finance', 'Travel', 'Social',
  'Creative', 'Admin', 'Maintenance', 'Learning', 'Networking',

  // Processus
  'Planning', 'In Progress', 'Review', 'Completed', 'On Hold',
  'Pending', 'Approved', 'Rejected', 'Draft', 'Finalized',
  'Brainstorming', 'Research', 'Development', 'Testing', 'Deployment',
  'Feedback', 'Iteration', 'Documentation', 'Training', 'Support',

  // Compétences
  'Coding', 'Design', 'Writing', 'Marketing', 'Sales',
  'Management', 'Leadership', 'Communication', 'Problem-Solving', 'Analytical',
  'Creative Thinking', 'Time Management', 'Negotiation', 'Customer Service', 'Technical',
  'Data Analysis', 'Project Management', 'Research', 'Teaching', 'Consulting',

  // Technologies
  'Flutter', 'Dart', 'JavaScript', 'Python', 'Java',
  'C#', 'Ruby', 'PHP', 'Swift', 'Kotlin',
  'HTML', 'CSS', 'SQL', 'NoSQL', 'Cloud',
  'AI', 'Machine Learning', 'Blockchain', 'IoT', 'Cybersecurity',

  // Lieux
  'Home Office', 'Office', 'Remote', 'Client Site', 'Coworking Space',
  'Café', 'Library', 'Park', 'Gym', 'Outdoors',
  'Conference Room', 'Lab', 'Workshop', 'Studio', 'Classroom',
  'Field', 'Warehouse', 'Store', 'Event Venue', 'Virtual',

  // Priorité de la Tâche
  'High Priority', 'Medium Priority', 'Low Priority', 'Urgent', 'Important',
  'Critical', 'Non-Essential', 'Optional', 'Routine', 'ASAP',
  'Deadline Soon', 'Long-Term', 'Short-Term', 'Immediate', 'Scheduled',
  'Overdue', 'Upcoming', 'Backlog', 'Next', 'Someday',

  // État de la Tâche
  'Awaiting', 'In Queue', 'Blocked', 'Delegated', 'Cancelled',
  'Postponed', 'Rescheduled', 'Recurring', 'Automated', 'Manual',
  'Quick Win', 'Stretch Goal', 'Milestone', 'Phase', 'Iteration',
  'Sprint', 'Backlog Item', 'User Story', 'Bug', 'Feature',

  // Autres Tags
  'Collaboration', 'Innovation', 'Efficiency', 'Productivity', 'Quality',
  'Safety', 'Compliance', 'Sustainability', 'Innovation', 'Automation',
  'Optimization', 'Scalability', 'Reliability', 'Usability', 'Maintainability',
  'Performance', 'Security', 'Privacy', 'Accessibility', 'Integration'
];

  List<String> get tags => _tags;

  void addTag(String tag) {
    if (!_tags.contains(tag)) {
      _tags.add(tag);
      notifyListeners();
    }
  }

  void removeTag(String tag) {
    _tags.remove(tag);
    notifyListeners();
  }
}
