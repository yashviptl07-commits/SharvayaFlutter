/*
pkID:
CompanyId:4132*/

class MudraComplaintDeleteDeleteRequest {
  int pkID;
  int CompanyId;

  MudraComplaintDeleteDeleteRequest({this.pkID, this.CompanyId});

  MudraComplaintDeleteDeleteRequest.fromJson(Map<String, dynamic> json) {
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
