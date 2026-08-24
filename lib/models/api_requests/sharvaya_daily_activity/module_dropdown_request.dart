/*
pkID:0
LoginUserID:admin
PageNo:1
PageSize:10
CompanyId:9255*/
class ModulesDropDownListRequest {
  int pkID;
  String LoginUserID;
  int PageNo;
  int PageSize;
  int CompanyId;

  ModulesDropDownListRequest(
      {this.pkID,
        this.LoginUserID,
        this.PageNo,
        this.PageSize,
        this.CompanyId});

  ModulesDropDownListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    LoginUserID = json['LoginUserID'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['LoginUserID'] = this.LoginUserID;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}