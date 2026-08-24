/*
pkID:0
SearchKey:
PageNo:1
PageSize:11
LoginUserID:admin
CompanyId:7291*/

class MaterialInwardListRequestMeet {
  String pkID;
  String SearchKey;
  String PageNo;
  String PageSize;
  String LoginUserID;
  String CompanyId;

  MaterialInwardListRequestMeet({
    this.pkID,
    this.SearchKey,
    this.PageNo,
    this.PageSize,
    this.LoginUserID,
    this.CompanyId,
  });

  MaterialInwardListRequestMeet.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    SearchKey = json['SearchKey'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['SearchKey'] = this.SearchKey;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
