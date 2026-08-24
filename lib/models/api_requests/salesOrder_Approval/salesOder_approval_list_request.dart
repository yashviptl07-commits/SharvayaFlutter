class SalesOrderApprovalListRequest {
  String ApprovalStatus;
  String LoginUserID;
  String PageNo;
  String PageSize;
  String CompanyId;
  String SearchKey;


  SalesOrderApprovalListRequest({this.ApprovalStatus, this.LoginUserID,
      this.PageNo, this.PageSize, this.CompanyId,this.SearchKey});


  SalesOrderApprovalListRequest.fromJson(Map<String, dynamic> json) {
    ApprovalStatus = json['ApprovalStatus'];
    LoginUserID = json['LoginUserID'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
    SearchKey = json['SearchKey'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ApprovalStatus'] = this.ApprovalStatus;
    data['LoginUserID'] = this.LoginUserID;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;
    data['SearchKey']=this.SearchKey;

    return data;
  }
}