class CountMeeting {
  final int countVisit;

  CountMeeting({
    required this.countVisit,
  });

  factory CountMeeting.fromJson(Map<String, dynamic> json) {
    return CountMeeting(
      countVisit: json['countVisit'],
    );
  }
}
