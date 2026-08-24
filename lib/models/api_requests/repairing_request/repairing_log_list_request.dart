/*
OutwardNo:OT-APR24-013
CompanyId:0*/
class RepairingLogListRequest {
  String HeaderID;
  String LoginUserID;
  String CompanyId;

  RepairingLogListRequest({this.HeaderID, this.LoginUserID, this.CompanyId});


  RepairingLogListRequest.fromJson(Map<String, dynamic> json) {
    HeaderID = json['HeaderID'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HeaderID'] = this.HeaderID;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}