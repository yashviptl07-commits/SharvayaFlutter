/*
OutwardNo:OT-JAN24-002
CompanyId:0*/
class RepairingDetailsDeleteRequest {
  String RepairingNo;
  String CompanyId;

  RepairingDetailsDeleteRequest({this.RepairingNo, this.CompanyId});

  RepairingDetailsDeleteRequest.fromJson(Map<String, dynamic> json) {
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
