import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Atttend_Visit/Mudra_AttendVisit_delete_request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Atttend_Visit/Mudra_Attend_Visit_Add_Update_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Atttend_Visit/Mudra_Attend_Visit_List_Screen_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_Assinto_DropDown_List_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_Complaint_Add_Update_request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_Complaint_Delete_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_Complaint_List_Screen_request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_History_List_Screen_request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_SericeTag_DropDown_List_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_project_List_DropDown_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_quick_suport_request/Mudra_quick_suport_list_request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Attend_Visit_response/Mudra_Attend_Visit_list_response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Attend_Visit_response/Mudra_Attend_Visit_save_Response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Complait_response/Mudra_Assign_To_DropDown_List_Response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Complait_response/Mudra_Complaint_List_Screen_response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Complait_response/Mudra_Complaint_Save_Response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Complait_response/Mudra_Complsint_history_response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Complait_response/Mudra_Project_List_DropDwon_Response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Complait_response/Mudra_ServiceTag_DropDown_response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_quick_suport_response/Mudra_quick_suport_list_response.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/models/api_requests/customer/customer_label_value_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/transection_mode_list_request.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/to_do/transection_mode_list_response.dart';
import 'package:soleoserp/repositories/repository.dart';

part 'mudra_events.dart';
part 'mudra_states.dart';

class MudraBloc extends Bloc<MudraEvents, MudraStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  MudraBloc(this.baseBloc) : super(MudraInitialState());

  @override
  Stream<MudraStates> mapEventToState(MudraEvents event) async* {
    /// sets state based on events
    if (event is MudraSearchBankVoucherCustomerListByNameCallEvent) {
      yield* _mapFollowupCustomerListByNameCallEventToState(event);
    }
    if (event is MudraBankVoucherListEvent) {
      yield* _mapMayankBankVoucherListEventState(event);
    }
    if (event is MudraComplaintDeleteEvent) {
      yield* _mapMayankBankVoucherDeleteEventState(event);
    }
    if (event is MudraAssignToListEvent) {
      yield* _mapMudraAssignToEventState(event);
    }
    if (event is MudraProjectListEvent) {
      yield* _mapMudraProjectlistEventState(event);
    }
    if (event is MudraCompliantAddUpdateSaveCallEvent) {
      yield* _mapMudraCompliantAddEditEventState(event);
    }
    if (event is MudraServiceTagListEvent) {
      yield* _mapMudraServiceTaglistEventState(event);
    }
    if (event is MudraComplaintHistoryListEvent) {
      yield* _mapToDoWorkLogListEventToState(event);
    }
    if (event is MudraAttendVisitListEvent) {
      yield* _mapMudraAttensVisitListEventState(event);
    }
    if (event is MudraAttendVisitDeleteEvent) {
      yield* _mapMayankAttendVisitDeleteEventState(event);
    }
    if (event is TransectionModeCallEvent) {
      yield* _mapTransectionModeCallEventToState(event);
    }
    if (event is MudraAttendVisitAddUpdateSaveCallEvent) {
      yield* _mapMudraAttendVisitAddEditEventState(event);
    }
    if (event is MudraQuickSupportVisitListEvent) {
      yield* _mapQuickSupportListEventState(event);
    }
  }

  ///event functions to states implementation
  Stream<MudraStates> _mapFollowupCustomerListByNameCallEventToState(
      MudraSearchBankVoucherCustomerListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerLabelvalueRsponse response =
          await userRepository.getCustomerListSearchByName(event.request);
      yield MudraBankVoucherCustomerListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MudraStates> _mapMayankBankVoucherListEventState(
      MudraBankVoucherListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MudraComplaintListResponse response =
          await userRepository.MaudraComplaintList(
              event.pageNo, event.mayankBankVoucherListRequest);
      yield MudraBankVoucherListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MudraStates> _mapMayankBankVoucherDeleteEventState(
      MudraComplaintDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository.MaudraComplaintDeleteAPI(
          event.mudraComplaintDeleteDeleteRequest);
      yield MudraCompaintDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MudraStates> _mapMudraAssignToEventState(
      MudraAssignToListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MudraAssignToResponse respo =
          await userRepository.MudraAssignToListAPI(event.mudraAssignToRequest);
      yield MudraAssignToListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MudraStates> _mapMudraProjectlistEventState(
      MudraProjectListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MudraProjectListResponse respo = await userRepository.MudraPrjectListAPI(
          event.mudraProjectListRequest);
      yield MudraProjectListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MudraStates> _mapMudraCompliantAddEditEventState(
      MudraCompliantAddUpdateSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MudraComplaintSaveResponse respo =
          await userRepository.MudraComlaintAddEditAPI(
              event.mudraComplaintSaveRequest);
      yield MudraCompliantAddUpdateSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MudraStates> _mapMudraServiceTaglistEventState(
      MudraServiceTagListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MudraServiceListResponse respo = await userRepository.MudraServiceListAPI(
          event.mudraServiceListRequest);
      yield MudraServiceTagListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MudraStates> _mapToDoWorkLogListEventToState(
      MudraComplaintHistoryListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MudraHistoryListResponse toDoWorkLogListResponse =
          await userRepository.MudraComplaintHistoryMethod(
              event.mudraHistoryListRequest);
      yield MudraComplaintHistoryListState(toDoWorkLogListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MudraStates> _mapMudraAttensVisitListEventState(
      MudraAttendVisitListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MudraAttendVisitListResponse response =
          await userRepository.MaudraAttendVisitList(
              event.pageNo, event.mudraAttendVisitListRequest);
      yield MudraAttendListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MudraStates> _mapMayankAttendVisitDeleteEventState(
      MudraAttendVisitDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository.MaudraAttendVisitDeleteAPI(
          event.mudraAttendVisitDeleteDeleteRequest);
      yield MudraAttendDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MudraStates> _mapTransectionModeCallEventToState(
      TransectionModeCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      TransectionModeListResponse bankVoucherDeleteResponse =
          await userRepository.getTransectionModeList(event.request);
      yield TransectionModeResponseState(bankVoucherDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MudraStates> _mapMudraAttendVisitAddEditEventState(
      MudraAttendVisitAddUpdateSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MudraAttendVisitSaveResponse respo =
          await userRepository.MudraAttendVisitAddEditAPI(
              event.mudraAttendVisitSaveRequest);
      yield MudraAttendVisitAddUpdateSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MudraStates> _mapQuickSupportListEventState(
      MudraQuickSupportVisitListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MudraQuickSupportListResponse response =
          await userRepository.QuickSupportList(
              event.pageNo, event.mudraQuickSupportListRequest);
      yield MudraQuickSupportListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
