class MaterialIndentApprovalUpdateRequest {
  String pkID;
  String ApprovalStatus;
  String ApprovalRemarks;
  String LoginUserID;
  String CompanyId;

  MaterialIndentApprovalUpdateRequest({
    this.pkID,
    this.ApprovalStatus,
    this.ApprovalRemarks,
    this.LoginUserID,
    this.CompanyId,
  });

  MaterialIndentApprovalUpdateRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ApprovalStatus = json['ApprovalStatus'];
    ApprovalRemarks = json['ApprovalRemarks'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ApprovalStatus'] = this.ApprovalStatus;
    data['ApprovalRemarks'] = this.ApprovalRemarks;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
