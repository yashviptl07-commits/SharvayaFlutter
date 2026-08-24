/*
pkID:0
LoginUserID:admin
SearchKey:
PageNo:1
PageSize:10
CompanyId:45297*/

class MultiExpenseApprovalUpdateRequest {
  String pkID;
  String LoginUserID;
  String ApprovalStatus;
  String ApprovalRemarks;
  String CompanyId;

  MultiExpenseApprovalUpdateRequest(
      {this.pkID,
      this.LoginUserID,
      this.ApprovalStatus,
      this.ApprovalRemarks,
      this.CompanyId});

  MultiExpenseApprovalUpdateRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    LoginUserID = json['LoginUserID'];
    ApprovalStatus = json['ApprovalStatus'];
    ApprovalRemarks = json['ApprovalRemarks'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['LoginUserID'] = this.LoginUserID;
    data['ApprovalStatus'] = this.ApprovalStatus;
    data['ApprovalRemarks'] = this.ApprovalRemarks;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
