part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceEvents {}

///all events of AuthenticationEvents
class AttendanceCallEvent extends AttendanceEvents {
  final AttendanceApiRequest attendanceApiRequest;
  AttendanceCallEvent(this.attendanceApiRequest);
}

class FollowerEmployeeListCallEvent extends AttendanceEvents {
  final FollowerEmployeeListRequest followerEmployeeListRequest;
  FollowerEmployeeListCallEvent(this.followerEmployeeListRequest);
}

class AttendanceHolidayListCallEvent extends AttendanceEvents {
  final AttendanceHolidayApiRequest followerEmployeeListRequest;
  AttendanceHolidayListCallEvent(this.followerEmployeeListRequest);
}

class LeaveRequestCallEvent extends AttendanceEvents {
  final LeaveRequestListAPIRequest leaveRequestListAPIRequest;
  LeaveRequestCallEvent(this.leaveRequestListAPIRequest);
}

class AttendanceSaveCallEvent extends AttendanceEvents {
  final AttendanceSaveApiRequest attendanceSaveApiRequest;
  AttendanceSaveCallEvent(this.attendanceSaveApiRequest);
}

class AttendanceEmployeeListCallEvent extends AttendanceEvents {
  final AttendanceEmployeeListRequest attendanceEmployeeListRequest;
  AttendanceEmployeeListCallEvent(this.attendanceEmployeeListRequest);
}

class LocationAddressCallEvent extends AttendanceEvents {
  final LocationAddressRequest locationAddressRequest;

  LocationAddressCallEvent(this.locationAddressRequest);
}

/*
class ConstantRequestEvent extends AttendanceEvents {
  String CompanyID;
  final ConstantRequest request;

  ConstantRequestEvent(this.CompanyID, this.request);
}*/
