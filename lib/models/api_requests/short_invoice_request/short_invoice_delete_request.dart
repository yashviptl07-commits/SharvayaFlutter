/*
pkID:0
SearchKey:
PageNo:1
PageSize:11
LoginUserID:admin
CompanyId:7291*/

class ShortInvoiceDeleteRequest {
  String pkID;
  String CompanyId;

  ShortInvoiceDeleteRequest({
    this.pkID,
    this.CompanyId,
  });

  ShortInvoiceDeleteRequest.fromJson(Map<String, dynamic> json) {
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
