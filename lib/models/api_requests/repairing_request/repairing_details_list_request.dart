/*
OutwardNo:OT-APR24-013
CompanyId:0*/
class RepairingDetailsListRequest {
  String RepairingNo;
  String CompanyId;

  RepairingDetailsListRequest({
    this.RepairingNo,
    this.CompanyId});


  RepairingDetailsListRequest.fromJson(Map<String, dynamic> json) {
    RepairingNo = json['RepairingNo'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RepairingNo'] = this.RepairingNo;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}