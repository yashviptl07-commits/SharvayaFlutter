part of 'mudra_bloc.dart';

@immutable
abstract class MudraEvents {}

///all events of AuthenticationEvents

class MudraSearchBankVoucherCustomerListByNameCallEvent extends MudraEvents {
  final CustomerLabelValueRequest request;

  MudraSearchBankVoucherCustomerListByNameCallEvent(this.request);
}

class MudraBankVoucherListEvent extends MudraEvents {
  final MudraComplaintListRequest mayankBankVoucherListRequest;
  final int pageNo;

  MudraBankVoucherListEvent(this.pageNo, this.mayankBankVoucherListRequest);
}

class MudraComplaintDeleteEvent extends MudraEvents {
  final MudraComplaintDeleteDeleteRequest mudraComplaintDeleteDeleteRequest;

  MudraComplaintDeleteEvent(this.mudraComplaintDeleteDeleteRequest);
}

class MudraAssignToListEvent extends MudraEvents {
  final MudraAssignToRequest mudraAssignToRequest;

  MudraAssignToListEvent(this.mudraAssignToRequest);
}

class MudraProjectListEvent extends MudraEvents {
  final MudraProjectListRequest mudraProjectListRequest;

  MudraProjectListEvent(this.mudraProjectListRequest);
}

class MudraServiceTagListEvent extends MudraEvents {
  final MudraServiceListRequest mudraServiceListRequest;

  MudraServiceTagListEvent(this.mudraServiceListRequest);
}

class MudraCompliantAddUpdateSaveCallEvent extends MudraEvents {
  final MudraComplaintSaveRequest mudraComplaintSaveRequest;

  MudraCompliantAddUpdateSaveCallEvent(
    this.mudraComplaintSaveRequest,
  );
}

class MudraComplaintHistoryListEvent extends MudraEvents {
  final MudraHistoryListRequest mudraHistoryListRequest;

  MudraComplaintHistoryListEvent(this.mudraHistoryListRequest);
}

class MudraAttendVisitListEvent extends MudraEvents {
  final MudraAttendVisitListRequest mudraAttendVisitListRequest;
  final int pageNo;

  MudraAttendVisitListEvent(this.pageNo, this.mudraAttendVisitListRequest);
}

class MudraAttendVisitDeleteEvent extends MudraEvents {
  final MudraAttendVisitDeleteDeleteRequest mudraAttendVisitDeleteDeleteRequest;

  MudraAttendVisitDeleteEvent(this.mudraAttendVisitDeleteDeleteRequest);
}

class TransectionModeCallEvent extends MudraEvents {
  final TransectionModeListRequest request;

  TransectionModeCallEvent(this.request);
}

class MudraAttendVisitAddUpdateSaveCallEvent extends MudraEvents {
  final MudraAttendVisitSaveRequest mudraAttendVisitSaveRequest;

  MudraAttendVisitAddUpdateSaveCallEvent(
    this.mudraAttendVisitSaveRequest,
  );
}

class MudraQuickSupportVisitListEvent extends MudraEvents {
  final MudraQuickSupportListRequest mudraQuickSupportListRequest;
  final int pageNo;

  MudraQuickSupportVisitListEvent(
      this.pageNo, this.mudraQuickSupportListRequest);
}
