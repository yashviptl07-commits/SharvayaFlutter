/*
VisitStatus:completestatus
LoginUserID:admin
SearchKey:
PageNo:1
PageSize:10
CompanyId:7235*/

class MudraQuickSupportListRequest {
  String VisitStatus;
  String LoginUserID;
  String SearchKey;
  String PageNo;
  String PageSize;
  String CompanyId;
  String EmployeeID;

  MudraQuickSupportListRequest(
      {this.VisitStatus,
      this.LoginUserID,
      this.SearchKey,
      this.PageNo,
      this.PageSize,
      this.CompanyId,
      this.EmployeeID});

  MudraQuickSupportListRequest.fromJson(Map<String, dynamic> json) {
    VisitStatus = json['VisitStatus'];
    LoginUserID = json['LoginUserID'];
    SearchKey = json['SearchKey'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
    EmployeeID = json['EmployeeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VisitStatus'] = this.VisitStatus;
    data['LoginUserID'] = this.LoginUserID;
    data['SearchKey'] = this.SearchKey;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;
    data['EmployeeID'] = this.EmployeeID;

    return data;
  }
}
