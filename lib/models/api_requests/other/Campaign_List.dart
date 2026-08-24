/*
CampaignSubject:Followup - Visit
LoginUserID:admin
CompanyId:4132*/
class CampaignListRequest {
  String CampaignSubject;
  String LoginUserID;
  String CompanyId;

  CampaignListRequest({this.CampaignSubject, this.LoginUserID, this.CompanyId});

  CampaignListRequest.fromJson(Map<String, dynamic> json) {
    CampaignSubject = json['CampaignSubject'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CampaignSubject'] = this.CampaignSubject;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
