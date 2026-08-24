/*
pkID:
CompanyId:4132*/

class MayankBankVoucherDeleteRequest {
  int pkID;
  int CompanyId;

  MayankBankVoucherDeleteRequest({this.pkID, this.CompanyId});

  MayankBankVoucherDeleteRequest.fromJson(Map<String, dynamic> json) {
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
