/*
OrgCode:
LoginUserID:admin
SearchKey:
PageNo:1
PageSize:100
CompanyId:7235*/

class MudraAssignToRequest {
  String OrgCode;
  String LoginUserID;
  String SearchKey;
  String PageNo;
  String PageSize;
  String CompanyId;

  MudraAssignToRequest(
      {this.OrgCode,
      this.LoginUserID,
      this.SearchKey,
      this.PageNo,
      this.PageSize,
      this.CompanyId});

  MudraAssignToRequest.fromJson(Map<String, dynamic> json) {
    OrgCode = json['OrgCode'];
    LoginUserID = json['LoginUserID'];
    SearchKey = json['SearchKey'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrgCode'] = this.OrgCode;
    data['LoginUserID'] = this.LoginUserID;
    data['SearchKey'] = this.SearchKey;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
