class SalesOrderApprovalStatusListResponse {
  List<SalesOrderApprovalStatusListResponseDetails> details;
  int totalCount;

  SalesOrderApprovalStatusListResponse({this.details, this.totalCount});

  SalesOrderApprovalStatusListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details
            .add(new SalesOrderApprovalStatusListResponseDetails.fromJson(v));
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

class SalesOrderApprovalStatusListResponseDetails {
  int rowNum;
  int pkID;
  String inquiryStatus;
  String statusCategory;

  SalesOrderApprovalStatusListResponseDetails(
      {this.rowNum, this.pkID, this.inquiryStatus, this.statusCategory});

  SalesOrderApprovalStatusListResponseDetails.fromJson(
      Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    inquiryStatus = json['InquiryStatus'] == null ? "" : json['InquiryStatus'];
    statusCategory =
        json['StatusCategory'] == null ? "" : json['StatusCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InquiryStatus'] = this.inquiryStatus;
    data['StatusCategory'] = this.statusCategory;
    return data;
  }
}
