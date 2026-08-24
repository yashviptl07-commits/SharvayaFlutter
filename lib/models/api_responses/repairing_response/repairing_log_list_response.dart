class RepairingLogListResponse {
  List<RepairingLogListResponseDetails> details;
  int totalCount;

  RepairingLogListResponse({this.details, this.totalCount});

  RepairingLogListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new RepairingLogListResponseDetails.fromJson(v));
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

class RepairingLogListResponseDetails {
  int pkID;
  int headerID;
  String actionTaken;
  String actionDescription;
  int employeeID;
  String repairingStage;
  String createdDate;
  String createdBy;
  String employeeName;

  RepairingLogListResponseDetails(
      {this.pkID,
        this.headerID,
        this.actionTaken,
        this.actionDescription,
        this.employeeID,
        this.repairingStage,
        this.createdDate,
        this.createdBy,
        this.employeeName});

  RepairingLogListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    headerID = json['HeaderID']  == null ? 0 : json['HeaderID'];
    actionTaken = json['ActionTaken']  == null ? "" : json['ActionTaken'];
    actionDescription = json['ActionDescription']  == null ? "" : json['ActionDescription'];
    employeeID = json['EmployeeID']  == null ? 0 : json['EmployeeID'];
    repairingStage = json['RepairingStage']  == null ? "" : json['RepairingStage'];
    createdDate = json['CreatedDate']  == null ? "" : json['CreatedDate'];
    createdBy = json['CreatedBy']  == null ? "" : json['CreatedBy'];
    employeeName = json['EmployeeName']  == null ? "" : json['EmployeeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['HeaderID'] = this.headerID;
    data['ActionTaken'] = this.actionTaken;
    data['ActionDescription'] = this.actionDescription;
    data['EmployeeID'] = this.employeeID;
    data['RepairingStage'] = this.repairingStage;
    data['CreatedDate'] = this.createdDate;
    data['CreatedBy'] = this.createdBy;
    data['EmployeeName'] = this.employeeName;
    return data;
  }
}