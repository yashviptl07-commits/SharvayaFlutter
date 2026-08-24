class MaterialIndentListResponse {
  List<MaterialIndentListResponseDetails> details;
  int totalCount;

  MaterialIndentListResponse({this.details, this.totalCount});

  MaterialIndentListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MaterialIndentListResponseDetails.fromJson(v));
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

class MaterialIndentListResponseDetails {
  int rowNum;
  int pkID;
  int indentpkID;
  String indentNo;
  int productID;
  String productName;
  String bfrProdRemark;
  String unit;
  double quantity;
  String approvalStatus;
  String approvalRemarks;
  String indentDate;
  String remarks;
  String employeeName;
  String indentApprovalStatus;
  String approvedBy;
  String approvedOn;
  String createdEmployeeName;

  MaterialIndentListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.indentpkID,
      this.indentNo,
      this.productID,
      this.productName,
      this.bfrProdRemark,
      this.unit,
      this.quantity,
      this.approvalStatus,
      this.approvalRemarks,
      this.indentDate,
      this.remarks,
      this.employeeName,
      this.indentApprovalStatus,
      this.approvedBy,
      this.approvedOn,
      this.createdEmployeeName});

  MaterialIndentListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    indentpkID = json['IndentpkID'];
    indentNo = json['IndentNo'];
    productID = json['ProductID'];
    productName = json['ProductName'];
    bfrProdRemark = json['BfrProdRemark'];
    unit = json['Unit'];
    quantity = json['Quantity'];
    approvalStatus = json['ApprovalStatus'];
    approvalRemarks = json['ApprovalRemarks'];
    indentDate = json['IndentDate'];
    remarks = json['Remarks'];
    employeeName = json['EmployeeName'];
    indentApprovalStatus = json['IndentApprovalStatus'];
    approvedBy = json['ApprovedBy'];
    approvedOn = json['ApprovedOn'];
    createdEmployeeName = json['CreatedEmployeeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['IndentpkID'] = this.indentpkID;
    data['IndentNo'] = this.indentNo;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['BfrProdRemark'] = this.bfrProdRemark;
    data['Unit'] = this.unit;
    data['Quantity'] = this.quantity;
    data['ApprovalStatus'] = this.approvalStatus;
    data['ApprovalRemarks'] = this.approvalRemarks;
    data['IndentDate'] = this.indentDate;
    data['Remarks'] = this.remarks;
    data['EmployeeName'] = this.employeeName;
    data['IndentApprovalStatus'] = this.indentApprovalStatus;
    data['ApprovedBy'] = this.approvedBy;
    data['ApprovedOn'] = this.approvedOn;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    return data;
  }
}
