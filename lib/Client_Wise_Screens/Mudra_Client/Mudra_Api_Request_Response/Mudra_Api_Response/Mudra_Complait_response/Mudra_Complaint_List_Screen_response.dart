class MudraComplaintListResponse {
  List<MudraComplaintListResponseDetails> details;
  int totalCount;

  MudraComplaintListResponse({this.details, this.totalCount});

  MudraComplaintListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MudraComplaintListResponseDetails.fromJson(v));
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

class MudraComplaintListResponseDetails {
  int rowNum;
  int pkID;
  String complaintNo;
  String complaintDate;
  String complaintStatus;
  int customerID;
  String customerName;
  String productGroup;
  String referenceNo;
  String serviceType;
  String serviceTag;
  String complaintNotes;
  String complaintType;
  int employeeID;
  String employeeName;
  String preferredDate;
  String timeFrom;
  String timeTo;
  String createdBy;
  String assignFrom;
  String visitStatus;
  String complaintCategory;

  MudraComplaintListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.complaintNo,
      this.complaintDate,
      this.complaintStatus,
      this.customerID,
      this.customerName,
      this.productGroup,
      this.referenceNo,
      this.serviceType,
      this.serviceTag,
      this.complaintNotes,
      this.complaintType,
      this.employeeID,
      this.employeeName,
      this.preferredDate,
      this.timeFrom,
      this.timeTo,
      this.createdBy,
      this.assignFrom,
      this.visitStatus,
      this.complaintCategory});

  MudraComplaintListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    complaintNo = json['ComplaintNo'] == null ? "" : json['ComplaintNo'];
    complaintDate = json['ComplaintDate'] == null ? "" : json['ComplaintDate'];
    complaintStatus =
        json['ComplaintStatus'] == null ? "" : json['ComplaintStatus'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    productGroup = json['ProductGroup'] == null ? "" : json['ProductGroup'];
    referenceNo = json['ReferenceNo'] == null ? "" : json['ReferenceNo'];
    serviceType = json['ServiceType'] == null ? "" : json['ServiceType'];
    serviceTag = json['ServiceTag'] == null ? "" : json['ServiceTag'];
    complaintNotes =
        json['ComplaintNotes'] == null ? "" : json['ComplaintNotes'];
    complaintType = json['ComplaintType'] == null ? "" : json['ComplaintType'];
    employeeID = json['EmployeeID'] == null ? 0 : json['EmployeeID'];
    employeeName = json['EmployeeName'] == null ? "" : json['EmployeeName'];
    preferredDate = json['PreferredDate'] == null ? "" : json['PreferredDate'];
    timeFrom = json['TimeFrom'] == null ? "" : json['TimeFrom'];
    timeTo = json['TimeTo'] == null ? "" : json['TimeTo'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    assignFrom = json['AssignFrom'] == null ? "" : json['AssignFrom'];
    visitStatus = json['VisitStatus'] == null ? "" : json['VisitStatus'];
    complaintCategory =
        json['ComplaintCategory'] == null ? "" : json['ComplaintCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ComplaintNo'] = this.complaintNo;
    data['ComplaintDate'] = this.complaintDate;
    data['ComplaintStatus'] = this.complaintStatus;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['ProductGroup'] = this.productGroup;
    data['ReferenceNo'] = this.referenceNo;
    data['ServiceType'] = this.serviceType;
    data['ServiceTag'] = this.serviceTag;
    data['ComplaintNotes'] = this.complaintNotes;
    data['ComplaintType'] = this.complaintType;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['PreferredDate'] = this.preferredDate;
    data['TimeFrom'] = this.timeFrom;
    data['TimeTo'] = this.timeTo;
    data['CreatedBy'] = this.createdBy;
    data['AssignFrom'] = this.assignFrom;
    data['VisitStatus'] = this.visitStatus;
    data['ComplaintCategory'] = this.complaintCategory;
    return data;
  }
}
