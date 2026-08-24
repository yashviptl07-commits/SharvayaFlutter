/*
pkID:
CompanyId
pkID:
CompanyId:4132*/

class MudraAttendVisitDeleteDeleteRequest {
  int pkID;
  int CompanyId;

  MudraAttendVisitDeleteDeleteRequest({this.pkID, this.CompanyId});

  MudraAttendVisitDeleteDeleteRequest.fromJson(Map<String, dynamic> json) {
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
