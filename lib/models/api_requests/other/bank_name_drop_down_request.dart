/*
pkID:0
LoginUserID:admin
CompanyId:4132*/
class BankNameDropDownRequest {
  String pkID;
  String LoginUserID;
  String CompanyId;

  BankNameDropDownRequest({this.pkID, this.LoginUserID, this.CompanyId});

  BankNameDropDownRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID']; //json['TalukaCode'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}