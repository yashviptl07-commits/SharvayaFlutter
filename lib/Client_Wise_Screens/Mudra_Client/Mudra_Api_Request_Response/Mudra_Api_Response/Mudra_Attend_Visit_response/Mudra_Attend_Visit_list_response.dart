class MudraAttendVisitListResponse {
  List<MudraAttendVisitListResponseDetails> details;
  int totalCount;

  MudraAttendVisitListResponse({this.details, this.totalCount});

  MudraAttendVisitListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MudraAttendVisitListResponseDetails.fromJson(v));
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

class MudraAttendVisitListResponseDetails {
  int rowNum;
  int pkID;
  int complaintID;
  String complaintNo;
  int customerID;
  String customerName;
  String serviceTag;
  String visitDate;
  String timeFrom;
  String timeTo;
  String visitNotes;
  String visitType;
  String visitChargeType;
  double visitCharge;
  String complaintStatus;
  String visitDocument;
  String engineerNotes;
  String fromKMS;
  String toKMS;
  String createdBy;
  String createdDate;
  String createdByEmployee;
  int employeeID;
  String employeeName;

  MudraAttendVisitListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.complaintID,
      this.complaintNo,
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
      this.createdByEmployee,
      this.employeeID,
      this.employeeName});

  MudraAttendVisitListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    complaintID = json['ComplaintID'] == null ? 0 : json['ComplaintID'];
    complaintNo = json['ComplaintNo'] == null ? "" : json['ComplaintNo'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    serviceTag = json['ServiceTag'] == null ? "" : json['ServiceTag'];
    visitDate = json['VisitDate'] == null ? "" : json['VisitDate'];
    timeFrom = json['TimeFrom'] == null ? "" : json['TimeFrom'];
    timeTo = json['TimeTo'] == null ? "" : json['TimeTo'];
    visitNotes = json['VisitNotes'] == null ? "" : json['VisitNotes'];
    visitType = json['VisitType'] == null ? "" : json['VisitType'];
    visitChargeType =
        json['VisitChargeType'] == null ? "" : json['VisitChargeType'];
    visitCharge = json['VisitCharge'] == null ? 0.00 : json['VisitCharge'];
    complaintStatus =
        json['ComplaintStatus'] == null ? "" : json['ComplaintStatus'];
    visitDocument = json['VisitDocument'] == null ? "" : json['VisitDocument'];
    engineerNotes = json['EngineerNotes'] == null ? "" : json['EngineerNotes'];
    fromKMS = json['FromKMS'] == null ? "" : json['FromKMS'];
    toKMS = json['ToKMS'] == null ? "" : json['ToKMS'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    createdByEmployee =
        json['CreatedByEmployee'] == null ? "" : json['CreatedByEmployee'];
    employeeID = json['EmployeeID'] == null ? 0 : json['EmployeeID'];
    employeeName = json['EmployeeName'] == null ? "" : json['EmployeeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ComplaintID'] = this.complaintID;
    data['ComplaintNo'] = this.complaintNo;
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
    data['CreatedByEmployee'] = this.createdByEmployee;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    return data;
  }
}
