/*
pkID:0
LoginUserID:admin
PageNo:1
PageSize:5000
CompanyId:7313*/

class POTankerListRequest {
  String pkID;
  String PageNo;
  String PageSize;
  String LoginUserID;
  String CompanyId;

  POTankerListRequest(
      {this.pkID,
      this.PageNo,
      this.PageSize,
      this.LoginUserID,
      this.CompanyId});

  POTankerListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
