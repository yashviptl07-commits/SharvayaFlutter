/*
ApprovalStatus:Approved
LoginUserID:admin
Month:0
Year:2024
PageNo:1
PageSize:11
CompanyId:7291
*/
class POApprovalRequest {
  String ApprovalStatus;
  String LoginUserID;
  String SearchKey;
  String PageNo;
  String PageSize;
  String CompanyId;

  POApprovalRequest(
      {this.ApprovalStatus,
      this.LoginUserID,
      this.SearchKey,
      this.PageNo,
      this.PageSize,
      this.CompanyId});

  POApprovalRequest.fromJson(Map<String, dynamic> json) {
    ApprovalStatus = json['ApprovalStatus'];
    LoginUserID = json['LoginUserID'];
    SearchKey = json['SearchKey'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ApprovalStatus'] = this.ApprovalStatus;
    data['LoginUserID'] = this.LoginUserID;
    data['SearchKey'] = this.SearchKey;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
