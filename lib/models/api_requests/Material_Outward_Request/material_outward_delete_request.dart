/*
pkID:1
CompanyId:0
*/
class MaterialOutwardDeleteRequest {
  int pkID;
  String CompanyId;

  MaterialOutwardDeleteRequest({this.pkID, this.CompanyId});

  MaterialOutwardDeleteRequest.fromJson(Map<String, dynamic> json) {
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
