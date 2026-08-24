/*
CustomerID:141852
Mode:sales
LoginUserID:admin
CompanyId:4132*/

class MayankBankVoucherInqNoRequest {
  String CustomerID;
  String Mode;
  String LoginUserID;
  int CompanyId;

  MayankBankVoucherInqNoRequest(
      {this.CustomerID, this.Mode, this.LoginUserID, this.CompanyId});

  MayankBankVoucherInqNoRequest.fromJson(Map<String, dynamic> json) {
    Mode = json['Mode'];
    CustomerID = json['CustomerID'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.CustomerID;
    data['Mode'] = this.Mode;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
