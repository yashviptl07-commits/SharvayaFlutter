/*
pkID:1
ApprovalStatus:pending
LoginUserID:admin
CompanyId:7291
*/
class POApprovalSaveRequest {
  String pkID;
  String ApprovalStatus;
  String LoginUserID;
  String CompanyId;

  POApprovalSaveRequest({
    this.pkID,
    this.ApprovalStatus,
    this.LoginUserID,
    this.CompanyId,

  });

  POApprovalSaveRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ApprovalStatus = json['ApprovalStatus'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ApprovalStatus'] = this.ApprovalStatus;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
