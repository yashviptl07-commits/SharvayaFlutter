import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/models/api_requests/attendance/attendance_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/attendance/attendance_list_request.dart';
import 'package:soleoserp/models/api_requests/attendance/attendance_save_request.dart';
import 'package:soleoserp/models/api_requests/attendance/attendnace_holiday_request.dart';
import 'package:soleoserp/models/api_requests/leave_request/leave_request_list_request.dart';
import 'package:soleoserp/models/api_requests/other/follower_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/other/location_address_request.dart';
import 'package:soleoserp/models/api_responses/attendance/attendance_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/attendance/attendance_holiday_response.dart';
import 'package:soleoserp/models/api_responses/attendance/attendance_response_list.dart';
import 'package:soleoserp/models/api_responses/attendance/attendance_save_response.dart';
import 'package:soleoserp/models/api_responses/leave_request/leave_request_list_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/other/location_address_response.dart';
import 'package:soleoserp/repositories/repository.dart';

part 'attendance_events.dart';
part 'attendance_states.dart';

class AttendanceBloc extends Bloc<AttendanceEvents, AttendanceStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  AttendanceBloc(this.baseBloc) : super(AttendanceInitialState());

  @override
  Stream<AttendanceStates> mapEventToState(AttendanceEvents event) async* {
    /// sets state based on events
    if (event is AttendanceCallEvent) {
      yield* _mapAttendanceCallEventToState(event);
    }
    if (event is AttendanceHolidayListCallEvent) {
      yield* _mapAttendanceHolidayListCallEventToState(event);
    }
    if (event is LeaveRequestCallEvent) {
      yield* _mapLeaveRequestListCallEventToState(event);
    }
    if (event is FollowerEmployeeListCallEvent) {
      yield* _mapFollowerEmployeeByStatusCallEventToState(event);
    }
    if (event is AttendanceSaveCallEvent) {
      yield* _mapAttendanceSaveCallEventToState(event);
    }
    if (event is AttendanceEmployeeListCallEvent) {
      yield* _mapAttendanceEmployeeListCallEventToState(event);
    }
  }

  Stream<AttendanceStates> _mapAttendanceCallEventToState(
      AttendanceCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      Attendance_List_Response respo =
          await userRepository.getAttendanceList(event.attendanceApiRequest);

      yield AttendanceListCallResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendanceStates> _mapAttendanceHolidayListCallEventToState(
      AttendanceHolidayListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AttendanceHolidayApiResponse respo = await userRepository
          .getAttendanceHolidayApi(event.followerEmployeeListRequest);

      yield AttendanceHolidayListCallResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendanceStates> _mapLeaveRequestListCallEventToState(
      LeaveRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      LeaveRequestListResponse response = await userRepository
          .getAttendanceLeaveRequestList(event.leaveRequestListAPIRequest);
      yield LeaveRequestStatesResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendanceStates> _mapFollowerEmployeeByStatusCallEventToState(
      FollowerEmployeeListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowerEmployeeListResponse response = await userRepository
          .getFollowerEmployeeList(event.followerEmployeeListRequest);
      yield FollowerEmployeeListByStatusCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendanceStates> _mapAttendanceEmployeeListCallEventToState(
      AttendanceEmployeeListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      AttendanceEmployeeListResponse respo = await userRepository
          .attendanceEmployeeList(event.attendanceEmployeeListRequest);
      yield AttendanceEmployeeListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendanceStates> _mapAttendanceSaveCallEventToState(
      AttendanceSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      AttendanceSaveResponse respo =
          await userRepository.attendanceSave(event.attendanceSaveApiRequest);
      yield AttendanceSaveCallResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
