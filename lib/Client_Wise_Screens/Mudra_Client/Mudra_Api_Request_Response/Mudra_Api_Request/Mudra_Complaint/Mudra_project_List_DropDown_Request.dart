/*
pkID:0
LoginUserID:admin
Searchkey:
PageNo:1
PageSize:100
CompanyId:7235*/
class MudraProjectListRequest {
  String pkID;
  String LoginUserID;
  String Searchkey;
  String PageNo;
  String PageSize;
  String CompanyId;

  MudraProjectListRequest(
      {this.pkID,
      this.LoginUserID,
      this.Searchkey,
      this.PageNo,
      this.PageSize,
      this.CompanyId});

  MudraProjectListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    LoginUserID = json['LoginUserID'];
    Searchkey = json['Searchkey'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['LoginUserID'] = this.LoginUserID;
    data['Searchkey'] = this.Searchkey;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
