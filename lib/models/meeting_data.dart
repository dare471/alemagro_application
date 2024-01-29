class MeetingData {
  String type;
  String action;
  int userId;
  int clientId;
  int typeVisit;
  int placeMeeting;
  int contactId;
  String dateToVisit;
  String dateToStart;
  String dateToFinish;
  bool isAllDay;
  String targetDescription;
  String placeDescription;

  MeetingData({
    required this.type,
    required this.action,
    required this.userId,
    required this.clientId,
    required this.typeVisit,
    required this.placeMeeting,
    required this.contactId,
    required this.dateToVisit,
    required this.dateToStart,
    required this.dateToFinish,
    required this.isAllDay,
    required this.targetDescription,
    required this.placeDescription,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'action': action,
        'userId': userId,
        'clientId': clientId,
        'typeVisit': typeVisit,
        'placeMeeting': placeMeeting,
        'contactId': contactId,
        'dateToVisit': dateToVisit,
        'dateToStart': dateToStart,
        'dateToFinish': dateToFinish,
        'isAllDay': isAllDay,
        'targetDescription': targetDescription,
        'placeDescription': placeDescription,
      };
}
