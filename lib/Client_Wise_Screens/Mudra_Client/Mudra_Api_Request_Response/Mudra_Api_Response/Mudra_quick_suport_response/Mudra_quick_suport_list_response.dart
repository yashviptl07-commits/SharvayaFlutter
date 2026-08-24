class MudraQuickSupportListResponse {
  List<MudraQuickSupportListResponseDetails> details;
  int totalCount;

  MudraQuickSupportListResponse({this.details, this.totalCount});

  MudraQuickSupportListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MudraQuickSupportListResponseDetails.fromJson(v));
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

class MudraQuickSupportListResponseDetails {
  dynamic rowNum;
  String complaintNo;
  dynamic pkID;
  dynamic complaintID;
  dynamic customerID;
  String customerName;
  String serviceTag;
  String visitDate;
  String timeFrom;
  String timeTo;
  String visitNotes;
  String visitType;
  dynamic visitChargeType;
  dynamic visitCharge;
  String complaintStatus;
  String visitDocument;
  String engineerNotes;
  String fromKMS;
  String toKMS;
  String createdBy;
  String createdDate;
  dynamic updatedBy;
  dynamic updatedDate;
  dynamic employeeID;
  String visitCreatedBy;
  String visitAssignedTo;
  String complaintCreatedBy;
  String complaintAssignedTo;

  MudraQuickSupportListResponseDetails(
      {this.rowNum,
      this.complaintNo,
      this.pkID,
      this.complaintID,
      this.customerID,
      this.customerName,
      this.serviceTag,
      this.visitDate,
      this.timeFrom,
      this.timeTo,
      this.visitNotes,
      this.visitType,
      this.visitChargeType,
      this.visitCharge,
      this.complaintStatus,
      this.visitDocument,
      this.engineerNotes,
      this.fromKMS,
      this.toKMS,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.employeeID,
      this.complaintAssignedTo,
      this.complaintCreatedBy,
      this.visitAssignedTo,
      this.visitCreatedBy});

  MudraQuickSupportListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    complaintNo = json['ComplaintNo'] == null ? "" : json['ComplaintNo'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    complaintID = json['ComplaintID'] == null ? 0 : json['ComplaintID'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    serviceTag = json['ServiceTag'] == null ? "" : json['ServiceTag'];
    visitDate = json['VisitDate'] == null ? "" : json['VisitDate'];
    timeFrom = json['TimeFrom'] == null ? "" : json['TimeFrom'];
    timeTo = json['TimeTo'] == null ? "" : json['TimeTo'];
    visitNotes = json['VisitNotes'] == null ? "" : json['VisitNotes'];
    visitType = json['VisitType'] == null ? "" : json['VisitType'];
    visitChargeType =
        json['VisitChargeType'] == null ? 0 : json['VisitChargeType'];
    visitCharge = json['VisitCharge'] == null ? 0 : json['VisitCharge'];
    complaintStatus =
        json['ComplaintStatus'] == null ? "" : json['ComplaintStatus'];
    visitDocument = json['VisitDocument'] == null ? "" : json['VisitDocument'];
    engineerNotes = json['EngineerNotes'] == null ? "" : json['EngineerNotes'];
    fromKMS = json['FromKMS'] == null ? "" : json['FromKMS'];
    toKMS = json['ToKMS'] == null ? "" : json['ToKMS'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    updatedBy = json['UpdatedBy'] == null ? 0 : json['UpdatedBy'];
    updatedDate = json['UpdatedDate'] == null ? 0 : json['UpdatedDate'];
    employeeID = json['EmployeeID'] == null ? 0 : json['EmployeeID'];
    visitCreatedBy =
        json['VisitCreatedBy'] == null ? "" : json['VisitCreatedBy'];
    visitAssignedTo =
        json['VisitAssignedTo'] == null ? "" : json['VisitAssignedTo'];
    complaintCreatedBy =
        json['ComplaintCreatedBy'] == null ? "" : json['ComplaintCreatedBy'];
    complaintAssignedTo =
        json['ComplaintAssignedTo'] == null ? "" : json['ComplaintAssignedTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['ComplaintNo'] = this.complaintNo;
    data['pkID'] = this.pkID;
    data['ComplaintID'] = this.complaintID;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['ServiceTag'] = this.serviceTag;
    data['VisitDate'] = this.visitDate;
    data['TimeFrom'] = this.timeFrom;
    data['TimeTo'] = this.timeTo;
    data['VisitNotes'] = this.visitNotes;
    data['VisitType'] = this.visitType;
    data['VisitChargeType'] = this.visitChargeType;
    data['VisitCharge'] = this.visitCharge;
    data['ComplaintStatus'] = this.complaintStatus;
    data['VisitDocument'] = this.visitDocument;
    data['EngineerNotes'] = this.engineerNotes;
    data['FromKMS'] = this.fromKMS;
    data['ToKMS'] = this.toKMS;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['EmployeeID'] = this.employeeID;
    data['VisitCreatedBy'] = this.visitCreatedBy;
    data['VisitAssignedTo'] = this.visitAssignedTo;
    data['ComplaintCreatedBy'] = this.complaintCreatedBy;
    data['ComplaintAssignedTo'] = this.complaintAssignedTo;
    return data;
  }
}
