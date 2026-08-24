/*
pkID:0
ListMode:
SearchKey:
PageNo:1
PageSize:10
LoginUserID:admin
CompanyId:4132*/
class ProductGroupDropDownListRequest {
  String pkID;
  String ListMode;
  String SearchKey;
  String PageNo;
  String PageSize;
  String LoginUserID;
  String CompanyId;

  ProductGroupDropDownListRequest({this.pkID, this.ListMode, this.SearchKey,
      this.PageNo, this.PageSize, this.LoginUserID, this.CompanyId});

  ProductGroupDropDownListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ListMode = json['ListMode'];
    SearchKey = json['SearchKey'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['CompanyId'] = this.CompanyId;
    data['ListMode'] = this.ListMode;
    data['SearchKey'] = this.SearchKey;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['LoginUserID'] = this.LoginUserID;

    return data;
  }
}