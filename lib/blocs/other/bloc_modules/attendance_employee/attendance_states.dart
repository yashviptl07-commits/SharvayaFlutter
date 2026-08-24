part of 'attendance_bloc.dart';

abstract class AttendanceStates extends BaseStates {
  const AttendanceStates();
}

///all states of AuthenticationStates
class AttendanceInitialState extends AttendanceStates {}

class AttendanceListCallResponseState extends AttendanceStates {
  final Attendance_List_Response response;
  AttendanceListCallResponseState(this.response);
}

class FollowerEmployeeListByStatusCallResponseState extends AttendanceStates {
  final FollowerEmployeeListResponse response;

  FollowerEmployeeListByStatusCallResponseState(this.response);
}

class AttendanceHolidayListCallResponseState extends AttendanceStates {
  final AttendanceHolidayApiResponse response;

  AttendanceHolidayListCallResponseState(this.response);
}

class LeaveRequestStatesResponseState extends AttendanceStates {
  LeaveRequestListResponse leaveRequestListResponse;

  LeaveRequestStatesResponseState(this.leaveRequestListResponse);
}

class AttendanceSaveCallResponseState extends AttendanceStates {
  final AttendanceSaveResponse response;
  AttendanceSaveCallResponseState(this.response);
}

class AttendanceEmployeeListResponseState extends AttendanceStates {
  final AttendanceEmployeeListResponse response;
  AttendanceEmployeeListResponseState(this.response);
}

class LocationAddressResponseState extends AttendanceStates {
  LocationAddressResponse locationAddressResponse;

  LocationAddressResponseState(this.locationAddressResponse);
}
