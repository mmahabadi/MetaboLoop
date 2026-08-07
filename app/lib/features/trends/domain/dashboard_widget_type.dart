enum DashboardWidgetType {
  weightTrend(label: 'Weight trend'),
  macroAdherence(label: 'Macro adherence'),
  expenditure(label: 'Expenditure'),
  streaks(label: 'Streaks'),
  habits(label: 'Habits'),
  micronutrients(label: 'Micronutrients');

  const DashboardWidgetType({required this.label});

  final String label;
}
