import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/models/api_requests/ToDo_request/to_do_delete_request.dart';
import 'package:soleoserp/models/api_requests/attendance/attendance_list_request.dart';
import 'package:soleoserp/models/api_requests/attendance/attendance_save_request.dart';
import 'package:soleoserp/models/api_requests/attendance/punch_attendence_save_request.dart';
import 'package:soleoserp/models/api_requests/attendance/punch_without_image_request.dart';
import 'package:soleoserp/models/api_requests/constant_master/constant_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_label_value_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_filter_list_request.dart';
import 'package:soleoserp/models/api_requests/other/all_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/invoice_document_delete_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/invoice_document_upload_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/invoice_documnet_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/module_sharing_save_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/task_category_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_employee_not_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_header_save_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_module_sharing_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_save_sub_details_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_worklog_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/todo_widget_list_request.dart';
import 'package:soleoserp/models/api_requests/to_do_office/to_do_office_list_request.dart';
import 'package:soleoserp/models/api_responses/attendance/attendance_response_list.dart';
import 'package:soleoserp/models/api_responses/attendance/attendance_save_response.dart';
import 'package:soleoserp/models/api_responses/attendance/punch_attendence_save_response.dart';
import 'package:soleoserp/models/api_responses/attendance/punch_without_image_response.dart';
import 'package:soleoserp/models/api_responses/constant_master/constant_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_filter_list_response.dart';
import 'package:soleoserp/models/api_responses/other/all_employee_List_response.dart';
import 'package:soleoserp/models/api_responses/to_do/nvoice_document_list_response.dart';
import 'package:soleoserp/models/api_responses/to_do/task_category_list_response.dart';
import 'package:soleoserp/models/api_responses/to_do/to_do_delete_response.dart';
import 'package:soleoserp/models/api_responses/to_do/to_do_employee_noto_response.dart';
import 'package:soleoserp/models/api_responses/to_do/to_do_header_save_response.dart';
import 'package:soleoserp/models/api_responses/to_do/to_do_module_sharing_list_response.dart';
import 'package:soleoserp/models/api_responses/to_do/to_do_save_sub_details_response.dart';
import 'package:soleoserp/models/api_responses/to_do/to_do_worklog_list_response.dart';
import 'package:soleoserp/models/api_responses/to_do/todo_list_response.dart';
import 'package:soleoserp/models/api_responses/to_do_office/to_do_office_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:soleoserp/models/pushnotification/fcm_notification_response.dart';
import 'package:soleoserp/models/pushnotification/get_report_to_token_request.dart';
import 'package:soleoserp/models/pushnotification/get_report_to_token_response.dart';
import 'package:soleoserp/repositories/repository.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

part 'todo_events.dart';
part 'todo_states.dart';

class ToDoBloc extends Bloc<ToDoEvents, ToDoStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  ToDoBloc(this.baseBloc) : super(ToDoInitialState());

  @override
  Stream<ToDoStates> mapEventToState(ToDoEvents event) async* {
    /// sets state based on events
    if (event is ToDoWidgetListCallEvent) {
      yield* _mapToDoWidgetListCallEventToState(event);
    }

    if (event is ToDoListCallEvent) {
      yield* _mapToDoListCallEventToState(event);
    }
    if (event is FuelDocumentListRequestEvent) {
      yield* _mapFuelDocumentListRequestEventState(event);
    }
    if (event is TaskCategoryListCallEvent) {
      yield* _mapTaskCategoryCallEventToState(event);
    }
    if (event is ToDoSaveHeaderEvent) {
      yield* _mapToDoSaveHeaderEventToState(event);
    }

    if (event is ToDoSaveHeaderOtherEvent) {
      yield* _mapToDoSaveHeaderOtherEventToState(event);
    }

    if (event is ToDoSaveSubDetailsEvent) {
      yield* _mapToDoSaveSubDetailsEventToState(event);
    }
    if (event is ToDoWorkLogListEvent) {
      yield* _mapToDoWorkLogListEventToState(event);
    }

    if (event is ToDoDeleteEvent) {
      yield* _mapDeleteStateEvent(event);
    }

    if (event is SearchFollowupCustomerListByNameCallEvent) {
      yield* _mapFollowupCustomerListByNameCallEventToState(event);
    }

    if (event is ToDoTodayListCallEvent) {
      yield* _mapToDoTodayListCallEventToState(event);
    }

    if (event is ToDoFutureListCallEvent) {
      yield* _mapToDoFutureListCallEventToState(event);
    }
    if (event is ToDoPendingOverDueListCallEvent) {
      yield* _mapToDoPendingOverDueListCallEventToState(event);
    }
    //
    if (event is ToDoOverDueListCallEvent) {
      yield* _mapToDoOverDueListCallEventToState(event);
    }

    if (event is ToDoTComplitedListCallEvent) {
      yield* _mapToDoCompltedListCallEventToState(event);
    }

    if (event is FCMNotificationRequestEvent) {
      yield* _map_fcm_notificationEvent_state(event);
    }
    if (event is FCMNotificationRequestNewEvent) {
      yield* _map_fcm_notificationEvent_new_state(event);
    }
    if (event is GetReportToTokenRequestEvent) {
      yield* _map_GetReportToTokenRequestEventState(event);
    }

    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }

    if (event is FollowupFilterListCallEvent) {
      yield* _mapFollowupFilterListCallEventToState(event);
    }

    if (event is FollowupMissedFilterListCallEvent) {
      yield* _mapFollowupMissedFilterListCallEventToState(event);
    }

    if (event is FollowupFutureFilterListCallEvent) {
      yield* _mapFollowupFutureFilterListCallEventToState(event);
    }
    if (event is AttendanceCallEvent) {
      yield* _mapAttendanceCallEventToState(event);
    }

    if (event is ConstantRequestEvent) {
      yield* _mapConstantRequestEventToState(event);
    }
    if (event is PunchAttendanceSaveRequestEvent) {
      yield* _mapPunchAttendanceSaveRequestEventToState(event);
    }
    if (event is AttendanceSaveCallEvent) {
      yield* _mapAttendanceSaveCallEventToState(event);
    }
    if (event is PunchWithoutImageAttendanceSaveRequestEvent) {
      yield* _mapPunchWithoutImageAttendanceSaveRequestEventToState(event);
    }
    if(event is ToDoModuleSharingListApiRequestEvent) {
      yield* _mapToDoModuleSharingListApiRequestEventToState(event);
    }
    if(event is GetEmployeeFromHeaderListRequestEvent) {
      yield* _mapTGetEmployeeFromHeaderListEventToState(event);
    }
    if(event is ToDoSaveWithTagEmployeeHeaderEvent) {
      yield* _mapToDoSaveWithTagEmployeeHeaderEventToState(event);
    }
    if(event is ALLEmployeeNameCallEvent) {
      yield* _mapALLEmployeeNameListCallEventToState(event);
    }
  }

  ///event functions to states implementation
  Stream<ToDoStates> _mapToDoWidgetListCallEventToState(
      ToDoWidgetListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ToDoListResponse response =
          await userRepository.getToDoWidgetList(event.toDoListApiRequest);
      yield ToDoWidgetListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  ///event functions to states implementation
  Stream<ToDoStates> _mapToDoListCallEventToState(
      ToDoListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ToDoListResponse response =
      await userRepository.getToDoList(event.toDoListApiRequest);
      yield ToDoListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapFuelDocumentListRequestEventState(
      FuelDocumentListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InvoiceDocumentListResponse response =
      await userRepository.toDoDocumentListAPI(
          event.vehicleModuleListRequest);
      List<File> DocumentList = [];
      for (int i = 0; i < response.details.length; i++) {
         try {
          String uriString = event.SiteURL +
              "/ModuleDocs/" +
              response.details[i].docName;
          print(uriString);// Uri string
          try {
            Directory dir = await path_provider.getTemporaryDirectory();
            dir.exists();
            String pathName = path.join(dir.path, response.details[i].docName);
            await Dio().download(uriString, pathName);
            File file = await toFile(pathName);
            DocumentList.add(file);
          } catch (e) {
            print("Download Failed.\n\n" + e.toString());
          }
        } on UnsupportedError catch (e) {
          print(e.message); // Unsupported error for uri not supported
        } on IOException catch (e) {
          print(e); // IOException for system error
        } catch (e) {
          print(e); // General exception
        }
      }

      yield FualDocumentListResponseState(
          response, event.vehicleFuelDetails, DocumentList);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  //ToDoFutureListCallEvent

  Stream<ToDoStates> _mapToDoTodayListCallEventToState(
      ToDoTodayListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      OfficeToDoListResponse response =
          await userRepository.getOfficeTodoList(event.toDoListApiRequest);

      yield ToDoTodayListCallResponseState(
          response, event.toDoListApiRequest.PageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapToDoFutureListCallEventToState(
      ToDoFutureListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      OfficeToDoListResponse response =
          await userRepository.getOfficeTodoList(event.toDoListApiRequest);
      yield ToDoFutureListCallResponseState(
          response, event.toDoListApiRequest.PageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapToDoPendingOverDueListCallEventToState(
      ToDoPendingOverDueListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      OfficeToDoListResponse response =
          await userRepository.getOfficeTodoList(event.toDoListApiRequest);
      yield ToDoPendingOverDueListResponseState(
          response, event.toDoListApiRequest.PageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  //ToDoFutureListCallEvent
  Stream<ToDoStates> _mapToDoOverDueListCallEventToState(
      ToDoOverDueListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      OfficeToDoListResponse response =
          await userRepository.getOfficeTodoList(event.toDoListApiRequest);
      yield ToDoOverDueListCallResponseState(
          response, event.toDoListApiRequest.PageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapToDoCompltedListCallEventToState(
      ToDoTComplitedListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      OfficeToDoListResponse response =
          await userRepository.getOfficeTodoList(event.toDoListApiRequest);
      yield ToDoCompletedListCallResponseState(
          response, event.toDoListApiRequest.PageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapTaskCategoryCallEventToState(
      TaskCategoryListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      TaskCategoryResponse customerDeleteResponse = await userRepository
          .taskCategoryDetails(event.taskCategoryListRequest);
      yield TaskCategoryCallResponseState(customerDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapToDoSaveHeaderEventToState(
      ToDoSaveHeaderEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ToDoSaveHeaderResponse customerDeleteResponse = await userRepository
          .todo_save_method(event.pkID, event.toDoHeaderSaveRequest);

      yield ToDoSaveHeaderState(event.context, customerDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapToDoSaveHeaderOtherEventToState(
      ToDoSaveHeaderOtherEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ToDoSaveHeaderResponse customerDeleteResponse = await userRepository
          .todo_save_method(event.pkID, event.toDoHeaderSaveRequest);

      if (customerDeleteResponse.details[0].column1.toString() != "-1") {
        await userRepository.ToDoInvoiceDocumentDeleteAPI(
            InvoiceDocumentDeleteRequest(
                KeyValue: customerDeleteResponse.details[0].column1.toString(),
                ModuleName: "todo",
                LoginUserID: event.toDoHeaderSaveRequest.LoginUserID,
                CompanyId: event.toDoHeaderSaveRequest.CompanyId.toString()));

        if (event.invoiceDocumentList.length != 0) {
          for (int i = 0; i < event.invoiceDocumentList.length; i++) {
            print("sfdsdssf789" + event.invoiceDocumentList[i].path.toString());

            if (event.invoiceDocumentList[i].path != "") {

              await userRepository.getTodoInvoicedocumentuploadapi(
                event.invoiceDocumentList[i],
                InvoiceDocumentUploadRequest(
                  pkID: "0",
                  ModuleName: "todo",
                  DocName: "todo" +
                      "-" +
                      customerDeleteResponse.details[0].column1.toString() +
                      "-" +
                      event.invoiceDocumentList[i].path
                          .split('/')
                          .last
                          .toString()
                          .trim(),
                  KeyValue: customerDeleteResponse.details[0].column1.toString(),
                  LoginUserID: event.toDoHeaderSaveRequest.LoginUserID,
                  CompanyId:
                  event.toDoHeaderSaveRequest.CompanyId.toString(),
                ),
              );
            }
          }
        }
      }

      yield ToDoSaveHeaderOtherState(event.context, customerDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapToDoSaveSubDetailsEventToState(
      ToDoSaveSubDetailsEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ToDoSaveSubDetailsResponse customerDeleteResponse = await userRepository
          .todo_save_sub_method(event.pkID, event.toDoSaveSubDetailsRequest);
      yield ToDoSaveSubDetailsState(event.context, customerDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapToDoWorkLogListEventToState(
      ToDoWorkLogListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ToDoWorkLogListResponse toDoWorkLogListResponse = await userRepository
          .toDoWorkLogListMethod(event.toDoWorkLogListRequest);
      yield ToDoWorkLogListState(toDoWorkLogListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapDeleteStateEvent(ToDoDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ToDoDeleteResponse toDoWorkLogListResponse = await userRepository
          .todoDeleteAPI(event.pkID, event.toDoDeleteRequest);
      yield ToDoDeleteResponseState(toDoWorkLogListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapFollowupCustomerListByNameCallEventToState(
      SearchFollowupCustomerListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerLabelvalueRsponse response =
          await userRepository.getCustomerListSearchByName(event.request);
      yield FollowupCustomerListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _map_fcm_notificationEvent_state(
      FCMNotificationRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FCMNotificationResponse response =
          await userRepository.fcm_get_api(event.request123);
      yield FCMNotificationResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _map_fcm_notificationEvent_new_state(
      FCMNotificationRequestNewEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FCMNotificationResponse response =
          await userRepository.fcm_get_api_New(event.request123);
      yield FCMNotificationResponseNewState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _map_GetReportToTokenRequestEventState(
      GetReportToTokenRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      GetReportToTokenResponse response =
          await userRepository.getreporttoTokenAPI(event.request);
      yield GetReportToTokenResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapUserMenuRightsRequestEventState(
      UserMenuRightsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      UserMenuRightsResponse respo = await userRepository.user_menurightsapi(
          event.MenuID, event.userMenuRightsRequest);
      yield UserMenuRightsResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapFollowupFilterListCallEventToState(
      FollowupFilterListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupFilterListResponse response =
          await userRepository.getFollowupFilterList(
              event.filtername, event.followupFilterListRequest);
      yield FollowupFilterListCallResponseState(
          event.followupFilterListRequest.PageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapFollowupMissedFilterListCallEventToState(
      FollowupMissedFilterListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupFilterListResponse response =
          await userRepository.getFollowupFilterList(
              event.filtername, event.followupFilterListRequest);
      yield FollowupMissedFilterListCallResponseState(
          event.followupFilterListRequest.PageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapFollowupFutureFilterListCallEventToState(
      FollowupFutureFilterListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupFilterListResponse response =
          await userRepository.getFollowupFilterList(
              event.filtername, event.followupFilterListRequest);
      yield FollowupFutureFilterListCallResponseState(
          event.followupFilterListRequest.PageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapAttendanceCallEventToState(
      AttendanceCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      // CustomerCategoryResponse loginResponse =

      /* List<CustomerCategoryResponse> customercategoryresponse*/
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

  Stream<ToDoStates> _mapConstantRequestEventToState(
      ConstantRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ConstantResponse respo =
          await userRepository.getConstantAPI(event.CompanyID, event.request);
      yield ConstantResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapPunchAttendanceSaveRequestEventToState(
      PunchAttendanceSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      PunchAttendenceSaveResponse response = await userRepository
          .getPunchIN_API(event.file, event.punchAttendanceSaveRequest);
      yield PunchAttendenceSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapAttendanceSaveCallEventToState(
      AttendanceSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      AttendanceSaveResponse respo =
          await userRepository.DashBoardattendanceSave(
              event.attendanceSaveApiRequest);
      yield AttendanceSaveCallResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapPunchWithoutImageAttendanceSaveRequestEventToState(
      PunchWithoutImageAttendanceSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PunchWithoutAttendenceSaveResponse respo =
          await userRepository.getwithoutImageAttendanceSaveAPI(event.request);
      yield PunchWithoutAttendenceSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }



  Stream<ToDoStates> _mapToDoModuleSharingListApiRequestEventToState(
      ToDoModuleSharingListApiRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ToDoModuleSharingListResponse response = await userRepository
          .getTodoModuleSharingListAPI(event.toDoModuleSharingListApiRequest);
      yield ToDoModuleSharingListResponseState(response,event.todoDetails);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapTGetEmployeeFromHeaderListEventToState(
      GetEmployeeFromHeaderListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ToDoEmployeeListSharingResponse response = await userRepository
          .GetEmployeeFromHeaderList(event.toDoModuleSharingListApiRequest);
      yield GetEmployeeFromHeaderListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapToDoSaveWithTagEmployeeHeaderEventToState(
      ToDoSaveWithTagEmployeeHeaderEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ToDoSaveHeaderResponse customerDeleteResponse = await userRepository
          .todo_save_method(event.pkID, event.toDoHeaderSaveRequest);



      List<ModuleSharingSaveRequest> tagemployeejsonarray = [];
      if(event.arrTagEmployeeList.isNotEmpty)
        {

          for(int i=0;i<event.arrTagEmployeeList.length;i++) {
            ModuleSharingSaveRequest moduleSharingSaveRequest = ModuleSharingSaveRequest(
                Module:"todo",
                ParentID:customerDeleteResponse.details[0].column1.toString(),///Header pkID
                EmployeeID:event.arrTagEmployeeList[i].pkID.toString(),
                LoginUserID:event.toDoHeaderSaveRequest.LoginUserID.toString(),
                CompanyId: event.toDoHeaderSaveRequest.CompanyId.toString(),

            );

            tagemployeejsonarray.add(moduleSharingSaveRequest);



          }

          await userRepository
              .todoTagEmployeeSaveJsonArrayAPI(tagemployeejsonarray);
        }
      yield ToDoSaveHeaderState(event.context, customerDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ToDoStates> _mapALLEmployeeNameListCallEventToState(
      ALLEmployeeNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ALL_EmployeeList_Response response =
      await userRepository.getALLEmployeeList(event.allEmployeeNameRequest);
      yield ALL_EmployeeNameListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

}
