class BreakDetailModel {
  String startTime;
  String endTime;
  String status;

  BreakDetailModel(
      {
        required this.startTime,
        required this.endTime,
        required this.status,
      });

  factory BreakDetailModel.fromJson(Map<String, dynamic> json) {
    return BreakDetailModel(
      startTime : json['start_time']??"",
      endTime : json['end_time']??"",
      status : json['status']??"",

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['status'] = status;
    return data;
  }
}
