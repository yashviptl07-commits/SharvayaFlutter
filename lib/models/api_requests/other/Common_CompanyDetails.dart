/*
CompanyId:4132
*/

class CommonCompanyDetailsRequest {
  String CompanyId;

  CommonCompanyDetailsRequest({this.CompanyId});

  CommonCompanyDetailsRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
