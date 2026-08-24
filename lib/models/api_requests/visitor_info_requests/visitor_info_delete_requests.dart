/*
pkID:17
CompanyId:52315*/

class VisitorInfoDeleteApiRequest {
  String pkID;
  String CompanyId;

  VisitorInfoDeleteApiRequest({
    this.pkID,
    this.CompanyId,
  });

  VisitorInfoDeleteApiRequest.fromJson(Map<String, dynamic> json) {
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
