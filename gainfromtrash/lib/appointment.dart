class Appointment {
  String? appointmentId;
  String? userId;
  String? selectedDay;
  String? selectedSessionType;
  String? selectedLocation;

  Appointment(
      {this.appointmentId,
      this.userId,
      this.selectedDay,
      this.selectedSessionType,
      this.selectedLocation,
      }
  );

  Appointment.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    userId = json['user_id'];
    selectedDay = json['selected_day'];
    selectedSessionType = json['selected_session'];
    selectedLocation = json['selected_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appointment_id '] = appointmentId;
    data['user_id'] = userId;
    data['selected_day'] = selectedDay;
    data['selected_session'] = selectedSessionType;
    data['selected_location'] = selectedLocation;
    return data;
  }
}