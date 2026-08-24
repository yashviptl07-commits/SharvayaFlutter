part of 'todo_bloc.dart';

@immutable
abstract class ToDoEvents {}

///all events of AuthenticationEvents
class ToDoWidgetListCallEvent extends ToDoEvents {
  final pageNo;
  final ToDoWidgetListApiRequest toDoListApiRequest;
  ToDoWidgetListCallEvent(this.pageNo, this.toDoListApiRequest);
}


class ToDoListCallEvent extends ToDoEvents {
  final pageNo;
  final ToDoListApiRequest toDoListApiRequest;
  ToDoListCallEvent(this.pageNo, this.toDoListApiRequest);
}

class FuelDocumentListRequestEvent extends ToDoEvents {
  String SiteURL;
  ToDoDetails vehicleFuelDetails;
  final InvoiceModuleListRequest vehicleModuleListRequest;

  FuelDocumentListRequestEvent(
      this.SiteURL, this.vehicleFuelDetails, this.vehicleModuleListRequest);
}

class ToDoTodayListCallEvent extends ToDoEvents {
  final OfficeToListRequest toDoListApiRequest;
  ToDoTodayListCallEvent(this.toDoListApiRequest);
}

/*class Today_To_Do_List_Event extends ToDoEvents {
  final OfficeToListRequest request;
  Today_To_Do_List_Event(this.request);
}*/

class ToDoPendingOverDueListCallEvent extends ToDoEvents {
  final OfficeToListRequest toDoListApiRequest;
  ToDoPendingOverDueListCallEvent(this.toDoListApiRequest);
}

class ToDoFutureListCallEvent extends ToDoEvents {
  final OfficeToListRequest toDoListApiRequest;
  ToDoFutureListCallEvent(this.toDoListApiRequest);
}

class ToDoOverDueListCallEvent extends ToDoEvents {
  final OfficeToListRequest toDoListApiRequest;
  ToDoOverDueListCallEvent(this.toDoListApiRequest);
}

class ToDoTComplitedListCallEvent extends ToDoEvents {
  final OfficeToListRequest toDoListApiRequest;
  ToDoTComplitedListCallEvent(this.toDoListApiRequest);
}

class TaskCategoryListCallEvent extends ToDoEvents {
  final TaskCategoryListRequest taskCategoryListRequest;

  TaskCategoryListCallEvent(this.taskCategoryListRequest);
}

class ToDoSaveHeaderEvent extends ToDoEvents {
  BuildContext context;
  final ToDoHeaderSaveRequest toDoHeaderSaveRequest;
  final int pkID;

  ToDoSaveHeaderEvent(this.context, this.pkID, this.toDoHeaderSaveRequest);
}

class ToDoSaveHeaderOtherEvent extends ToDoEvents {
  BuildContext context;
  final ToDoHeaderSaveRequest toDoHeaderSaveRequest;
  final int pkID;
  final List<File> invoiceDocumentList;

  ToDoSaveHeaderOtherEvent(this.context, this.pkID, this.toDoHeaderSaveRequest, this.invoiceDocumentList);
}

class ToDoSaveWithTagEmployeeHeaderEvent extends ToDoEvents {
  BuildContext context;
  final ToDoHeaderSaveRequest toDoHeaderSaveRequest;
  final int pkID;
  final List<ALL_Name_ID> arrTagEmployeeList;

  ToDoSaveWithTagEmployeeHeaderEvent(this.context, this.pkID,this.arrTagEmployeeList, this.toDoHeaderSaveRequest);
}

class ToDoSaveSubDetailsEvent extends ToDoEvents {
  BuildContext context;
  final ToDoSaveSubDetailsRequest toDoSaveSubDetailsRequest;
  final int pkID;

  ToDoSaveSubDetailsEvent(
      this.context, this.pkID, this.toDoSaveSubDetailsRequest);
}

class ToDoWorkLogListEvent extends ToDoEvents {
  final ToDoWorkLogListRequest toDoWorkLogListRequest;

  ToDoWorkLogListEvent(this.toDoWorkLogListRequest);
}

class ToDoDeleteEvent extends ToDoEvents {
  final ToDoDeleteRequest toDoDeleteRequest;
  final int pkID;

  ToDoDeleteEvent(this.pkID, this.toDoDeleteRequest);
}

class SearchFollowupCustomerListByNameCallEvent extends ToDoEvents {
  final CustomerLabelValueRequest request;

  SearchFollowupCustomerListByNameCallEvent(this.request);
}

class FCMNotificationRequestEvent extends ToDoEvents {
  //final FCMNotificationRequest request;
  var request123;
  FCMNotificationRequestEvent(this.request123);
}

class FCMNotificationRequestNewEvent extends ToDoEvents {
  //final FCMNotificationRequest request;
  var request123;
  FCMNotificationRequestNewEvent(this.request123);
}

class GetReportToTokenRequestEvent extends ToDoEvents {
  final GetReportToTokenRequest request;

  GetReportToTokenRequestEvent(this.request);
}

class UserMenuRightsRequestEvent extends ToDoEvents {
  String MenuID;

  final UserMenuRightsRequest userMenuRightsRequest;
  UserMenuRightsRequestEvent(this.MenuID, this.userMenuRightsRequest);
}

class FollowupFilterListCallEvent extends ToDoEvents {
  String filtername;
  final FollowupFilterListRequest followupFilterListRequest;

  FollowupFilterListCallEvent(this.filtername, this.followupFilterListRequest);
}

class FollowupMissedFilterListCallEvent extends ToDoEvents {
  String filtername;
  final FollowupFilterListRequest followupFilterListRequest;

  FollowupMissedFilterListCallEvent(
      this.filtername, this.followupFilterListRequest);
}

class FollowupFutureFilterListCallEvent extends ToDoEvents {
  String filtername;
  final FollowupFilterListRequest followupFilterListRequest;

  FollowupFutureFilterListCallEvent(
      this.filtername, this.followupFilterListRequest);
}

class AttendanceCallEvent extends ToDoEvents {
  final AttendanceApiRequest attendanceApiRequest;
  AttendanceCallEvent(this.attendanceApiRequest);
}

class ConstantRequestEvent extends ToDoEvents {
  String CompanyID;
  final ConstantRequest request;

  ConstantRequestEvent(this.CompanyID, this.request);
}

class PunchAttendanceSaveRequestEvent extends ToDoEvents {
  File file;
  final PunchAttendanceSaveRequest punchAttendanceSaveRequest;
  PunchAttendanceSaveRequestEvent(this.file, this.punchAttendanceSaveRequest);
}

class AttendanceSaveCallEvent extends ToDoEvents {
  final AttendanceSaveApiRequest attendanceSaveApiRequest;
  AttendanceSaveCallEvent(this.attendanceSaveApiRequest);
}

class PunchWithoutImageAttendanceSaveRequestEvent extends ToDoEvents {
  final PunchWithoutImageAttendanceSaveRequest request;

  PunchWithoutImageAttendanceSaveRequestEvent(this.request);
}


class ToDoModuleSharingListApiRequestEvent extends ToDoEvents {
  final ToDoModuleSharingListApiRequest toDoModuleSharingListApiRequest;
  final ToDoDetails todoDetails;
  ToDoModuleSharingListApiRequestEvent(this.toDoModuleSharingListApiRequest,this.todoDetails);
}

class GetEmployeeFromHeaderListRequestEvent extends ToDoEvents {
  final ToDoEmployeeListSharingRequest toDoModuleSharingListApiRequest;
  GetEmployeeFromHeaderListRequestEvent(this.toDoModuleSharingListApiRequest);
}

class ALLEmployeeNameCallEvent extends ToDoEvents {
  final ALLEmployeeNameRequest allEmployeeNameRequest;

  ALLEmployeeNameCallEvent(this.allEmployeeNameRequest);
}