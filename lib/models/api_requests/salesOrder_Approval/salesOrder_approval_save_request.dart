/*pkID:40152
ProjectStage:
ApprovalStatus:Pending
StatusRemarks:
LoginUserID:admin
CompanyId:4132*/

class SalesOrderApprovalSaveRequest {
  String pkID;
  String ProjectStage;
  String ApprovalStatus;
  String StatusRemarks;
  String LoginUserID;
  String CompanyId;


  SalesOrderApprovalSaveRequest({
      this.pkID,
      this.ProjectStage,
      this.ApprovalStatus,
      this.StatusRemarks,
      this.LoginUserID,
      this.CompanyId});



  SalesOrderApprovalSaveRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ProjectStage = json['ProjectStage'];
    ApprovalStatus = json['ApprovalStatus'];
    StatusRemarks = json['StatusRemarks'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ProjectStage'] = this.ProjectStage;
    data['ApprovalStatus'] = this.ApprovalStatus;
    data['StatusRemarks'] = this.StatusRemarks;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}