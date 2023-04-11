import 'package:flutter/widgets.dart';

class StaffAvailability{
  final String description;
  final Color color;
  final String response;


  StaffAvailability({
    required this.description,
    required this.color,
    required this.response,
  });
}

List<StaffAvailability> staffAvailabilityList=[
  StaffAvailability(description: "Monday 19 Sep 2021 to Tue 24 Sep 2021", color: const Color(0xff0FA958),  response: "Approved", ),
  StaffAvailability(description: "Monday 19 Sep 2021 to Tue 24 Sep 2021", color: const Color(0xffFC2E00),  response: "Declined",  ),
  StaffAvailability(description: "Monday 19 Sep 2021 to Tue 24 Sep 2021", color: const Color(0xff2E2E2E),  response: "Submitted",),

];