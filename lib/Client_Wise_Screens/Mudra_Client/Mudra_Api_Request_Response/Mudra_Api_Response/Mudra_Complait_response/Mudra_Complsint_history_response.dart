class MudraHistoryListResponse {
  List<MudraHistoryListResponseDetails> details;
  int totalCount;

  MudraHistoryListResponse({this.details, this.totalCount});

  MudraHistoryListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MudraHistoryListResponseDetails.fromJson(v));
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

class MudraHistoryListResponseDetails {
  int rowNum;
  int pkID;
  int complaintNo;
  int customerID;
  String serviceTag;
  String visitDate;
  String timeFrom;
  String timeTo;
  String visitNotes;
  String visitType;
  dynamic visitChargeType;
  double visitCharge;
  String complaintStatus;
  String visitDocument;
  String engineerNotes;
  String fromKMS;
  String toKMS;
  String createdBy;
  String createdDate;
  String createdByEmployee;

  MudraHistoryListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.complaintNo,
      this.customerID,
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
      this.createdByEmployee});

  MudraHistoryListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    complaintNo = json['ComplaintNo'] == null ? 0 : json['ComplaintNo'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    serviceTag = json['ServiceTag'] == null ? "" : json['ServiceTag'];
    visitDate = json['VisitDate'] == null ? "" : json['VisitDate'];
    timeFrom = json['TimeFrom'] == null ? "" : json['TimeFrom'];
    timeTo = json['TimeTo'] == null ? "" : json['TimeTo'];
    visitNotes = json['VisitNotes'] == null ? "" : json['VisitNotes'];
    visitType = json['VisitNotes'] == null ? "" : json['VisitNotes'];
    visitChargeType =
        json['VisitChargeType'] == null ? dynamic : json['VisitChargeType'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ComplaintNo'] = this.complaintNo;
    data['CustomerID'] = this.customerID;
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
    return data;
  }
}
