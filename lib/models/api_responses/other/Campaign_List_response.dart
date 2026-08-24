class CampaignListResponse {
  List<CampaignListResponseDetails> details;
  int totalCount;

  CampaignListResponse({this.details, this.totalCount});

  CampaignListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new CampaignListResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class CampaignListResponseDetails {
  int campaignID;
  String campaignCategory;
  String campaignSubject;
  String campaignHeader;
  String campaignFooter;
  String campaignImageUrl;
  String createdBy;
  String updatedBy;
  String createdDate;
  String updatedDate;

  CampaignListResponseDetails(
      {this.campaignID,
      this.campaignCategory,
      this.campaignSubject,
      this.campaignHeader,
      this.campaignFooter,
      this.campaignImageUrl,
      this.createdBy,
      this.updatedBy,
      this.createdDate,
      this.updatedDate});

  CampaignListResponseDetails.fromJson(Map<String, dynamic> json) {
    campaignID = json['CampaignID'];
    campaignCategory = json['CampaignCategory'];
    campaignSubject = json['CampaignSubject'];
    campaignHeader = json['CampaignHeader'];
    campaignFooter = json['CampaignFooter'];
    campaignImageUrl = json['CampaignImageUrl'];
    createdBy = json['CreatedBy'];
    updatedBy = json['UpdatedBy'];
    createdDate = json['CreatedDate'];
    updatedDate = json['UpdatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CampaignID'] = this.campaignID;
    data['CampaignCategory'] = this.campaignCategory;
    data['CampaignSubject'] = this.campaignSubject;
    data['CampaignHeader'] = this.campaignHeader;
    data['CampaignFooter'] = this.campaignFooter;
    data['CampaignImageUrl'] = this.campaignImageUrl;
    data['CreatedBy'] = this.createdBy;
    data['UpdatedBy'] = this.updatedBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedDate'] = this.updatedDate;
    return data;
  }
}
