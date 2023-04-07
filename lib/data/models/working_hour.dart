class WorkingHour {
  String? startingHour;
  String? endingHour;

  WorkingHour({
    this.startingHour,
    this.endingHour,
  });

  factory WorkingHour.fromMap(Map<String, dynamic> data) => WorkingHour(
        startingHour: data['starting_hour'],
        endingHour: data['ending_hour'],
      );

  Map<String, dynamic> toJson() => {
        "starting_hour": startingHour,
        "ending_hour": endingHour,
      };
}
