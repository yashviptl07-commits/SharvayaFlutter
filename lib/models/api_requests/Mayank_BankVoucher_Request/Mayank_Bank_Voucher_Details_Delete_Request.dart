/*
pkID:
CompanyId:4132*/

class MayankBankVoucherDeleteDetailsRequest {
  int pkID;
  String CompanyId;

  MayankBankVoucherDeleteDetailsRequest({this.pkID, this.CompanyId});

  MayankBankVoucherDeleteDetailsRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
