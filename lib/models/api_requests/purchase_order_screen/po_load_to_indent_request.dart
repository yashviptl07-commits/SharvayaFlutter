/*
No:,ID-DEC24-003,
CompanyId:7291*/

class PoFromTheIndentListRequest {
  String No;
  String CompanyId;

  PoFromTheIndentListRequest({
    this.No,
    this.CompanyId,
  });

  PoFromTheIndentListRequest.fromJson(Map<String, dynamic> json) {
    No = json['No'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['No'] = this.No;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}