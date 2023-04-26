class ShiftAvailabilityModel {
  String startDate;
  String endDate;
  String status;
  int availability;
  int userId;
  int id;


  ShiftAvailabilityModel(
      {
        required this.startDate,
        required this.endDate,
        required this.status,
        required this.availability,
        required this.userId,
        required this.id,
      });
//
  factory ShiftAvailabilityModel.fromJson(Map<String, dynamic> json) {

    return ShiftAvailabilityModel(
      startDate : json['start_date']??"",
      endDate : json['end_date']??"",
      status : json['status']??"",
      availability : json['availability'],
      userId : json['user_id'],
      id : json['id'],

    );
  }
//
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    data['availability'] = availability;
    data['user_id'] = userId;
    data['id'] = id;

    return data;
  }
}
