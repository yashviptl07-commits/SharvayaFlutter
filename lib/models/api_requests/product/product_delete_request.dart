/*
pkID:
CompanyId:4132*/

class ProductDeleteRequest {
  int pkID;
  String CompanyId;

  ProductDeleteRequest({this.pkID, this.CompanyId});

  ProductDeleteRequest.fromJson(Map<String, dynamic> json) {
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
