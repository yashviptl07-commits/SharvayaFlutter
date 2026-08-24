part of 'mudra_bloc.dart';

abstract class MudraStates extends BaseStates {
  const MudraStates();
}

///all states of AuthenticationStates

class MudraInitialState extends MudraStates {}

class MudraBankVoucherCustomerListByNameCallResponseState extends MudraStates {
  final CustomerLabelvalueRsponse response;

  MudraBankVoucherCustomerListByNameCallResponseState(this.response);
}

class MudraBankVoucherListResponseState extends MudraStates {
  final int newPage;
  final MudraComplaintListResponse response;
  MudraBankVoucherListResponseState(this.newPage, this.response);
}

class MudraCompaintDeleteResponseState extends MudraStates {
  final String response;

  MudraCompaintDeleteResponseState(this.response);
}

class MudraAssignToListResponseState extends MudraStates {
  final MudraAssignToResponse response;

  MudraAssignToListResponseState(this.response);
}

class MudraProjectListResponseState extends MudraStates {
  final MudraProjectListResponse response;

  MudraProjectListResponseState(this.response);
}

class MudraServiceTagListResponseState extends MudraStates {
  final MudraServiceListResponse response;

  MudraServiceTagListResponseState(this.response);
}

class MudraCompliantAddUpdateSaveResponseState extends MudraStates {
  final MudraComplaintSaveResponse mudraComplaintSaveResponse;

  MudraCompliantAddUpdateSaveResponseState(this.mudraComplaintSaveResponse);
}

class MudraComplaintHistoryListState extends MudraStates {
  final MudraHistoryListResponse mudraHistoryListResponse;

  MudraComplaintHistoryListState(this.mudraHistoryListResponse);
}

class MudraAttendListResponseState extends MudraStates {
  final int newPage;
  final MudraAttendVisitListResponse response;
  MudraAttendListResponseState(this.newPage, this.response);
}

class MudraAttendDeleteResponseState extends MudraStates {
  final String response;

  MudraAttendDeleteResponseState(this.response);
}

class TransectionModeResponseState extends MudraStates {
  final TransectionModeListResponse transectionModeListResponse;

  TransectionModeResponseState(this.transectionModeListResponse);
}

class MudraAttendVisitAddUpdateSaveResponseState extends MudraStates {
  final MudraAttendVisitSaveResponse mudraAttendVisitSaveResponse;

  MudraAttendVisitAddUpdateSaveResponseState(this.mudraAttendVisitSaveResponse);
}

class MudraQuickSupportListResponseState extends MudraStates {
  final int newPage;
  final MudraQuickSupportListResponse response;
  MudraQuickSupportListResponseState(this.newPage, this.response);
}
