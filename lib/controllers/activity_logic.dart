import 'package:dept_audit/views/staff/guest_lecture_screen.dart';
import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../../views/staff/attendence_screen.dart';
import '../../views/staff/code_of_conduct_screen.dart';
import '../../views/staff/publication_list_screen.dart';

class ActivityController extends ChangeNotifier {
  List<Activity> _activities = [];
  String _selectedPeriod = 'All';
  String _searchQuery = '';

  List<Activity> get activities => _activities;
  String get selectedPeriod => _selectedPeriod;
  String get searchQuery => _searchQuery;

  ActivityController() {
    loadActivities();
  }

  void loadActivities() {
    _activities = ActivityData.getAllActivities();
    notifyListeners();
  }

  List<Activity> get filteredActivities {
    List<Activity> filtered = _activities;
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((activity) =>
          activity.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return filtered;
  }

  void updateActivity(int id, {bool? isCompleted, String? comments}) {
    final index = _activities.indexWhere((activity) => activity.id == id);
    if (index != -1) {
      _activities[index] = _activities[index].copyWith(
        isCompleted: isCompleted ?? _activities[index].isCompleted,
        comments: comments ?? _activities[index].comments,
        completionDate: isCompleted == true ? DateTime.now() : _activities[index].completionDate,
      );
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  void toggleActivityCompletion(int id) {
    final index = _activities.indexWhere((activity) => activity.id == id);
    if (index != -1) {
      final activity = _activities[index];
      updateActivity(id, isCompleted: !activity.isCompleted);
    }
  }

  void addComment(int id, String comment) {
    updateActivity(id, comments: comment);
  }

  // Simplified activity click handler - accepts both int ID and Activity object
  void handleActivityClick(BuildContext context, dynamic activityOrId) {
    Activity activity;

    if (activityOrId is int) {
      // If passed an ID, find the activity
      activity = _activities.firstWhere((a) => a.id == activityOrId);
    } else if (activityOrId is Activity) {
      // If passed an Activity object, use it directly
      activity = activityOrId;
    } else {
      return; // Invalid input
    }

    String description = activity.description.toLowerCase();

    // Navigate to attendance screen
    if (activity.id == 2 || description.contains('attend')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AttendanceReportView()),
      );
    }
    // Navigate to code of conduct screen
    else if (description.contains('code of conduct')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CodeOfConductScreen()),
      );
    }
    else if (activity.id == 10 || description.contains('guest lecture organized by the department')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GuestLectureScreen()),
      );
    }
    // Navigate to publications screen
    else if (description.contains('publication')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PublicationFormPage()),
      );
    }
    // For other activities, toggle completion
    else {
      toggleActivityCompletion(activity.id);
    }
  }

  int get completedCount => _activities.where((a) => a.isCompleted).length;
  int get totalCount => _activities.length;
  double get completionPercentage => totalCount > 0 ? (completedCount / totalCount) * 100 : 0;

  List<Activity> get completedActivities => _activities.where((a) => a.isCompleted).toList();
  List<Activity> get pendingActivities => _activities.where((a) => !a.isCompleted).toList();

  void markAllAsCompleted() {
    for (int i = 0; i < _activities.length; i++) {
      _activities[i] = _activities[i].copyWith(
        isCompleted: true,
        completionDate: DateTime.now(),
      );
    }
    notifyListeners();
  }

  void resetAllActivities() {
    for (int i = 0; i < _activities.length; i++) {
      _activities[i] = _activities[i].copyWith(
        isCompleted: false,
        comments: '',
        completionDate: null,
      );
    }
    notifyListeners();
  }
}