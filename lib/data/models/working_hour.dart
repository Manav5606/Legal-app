class WorkingHour {
  final DateTime startingHour;
  final DateTime endingHour;

  WorkingHour({
    required this.startingHour,
    required this.endingHour,
  });

  factory WorkingHour.fromMap(Map<String, dynamic> data) => WorkingHour(
        startingHour: DateTime(data['starting_hour']),
        endingHour: data['ending_hour'],
      );

  Map<String, dynamic> toJson() => {
        "starting_hour": startingHour,
        "ending_hour": endingHour,
      };
}
