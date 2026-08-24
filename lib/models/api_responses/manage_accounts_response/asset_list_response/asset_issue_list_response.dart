class AssetIssueListResponse {
  List<AssetIssueListResponseDetails> details;
  int totalCount;

  AssetIssueListResponse({this.details, this.totalCount});

  AssetIssueListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new AssetIssueListResponseDetails.fromJson(v));
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

class AssetIssueListResponseDetails {
  int rowNum;
  int pkID;
  int assetID;
  String assetName;
  String assetNote;
  String createdEmployee;
  String createdDesignation;
  String employeeName;
  int employeeID;
  String modelNo;
  String assetNo;
  String iMEINo;
  String assetDate;
  String assetType;
  int projectID;
  String projectName;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;

  AssetIssueListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.assetID,
      this.assetName,
      this.assetNote,
      this.createdEmployee,
      this.createdDesignation,
      this.employeeName,
      this.employeeID,
      this.modelNo,
      this.assetNo,
      this.iMEINo,
      this.assetDate,
      this.assetType,
      this.projectID,
      this.projectName,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate});

  AssetIssueListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    assetID = json['AssetID'];
    assetName = json['AssetName'];
    assetNote = json['AssetNote'];
    createdEmployee = json['CreatedEmployee'];
    createdDesignation = json['CreatedDesignation'];
    employeeName = json['EmployeeName'];
    employeeID = json['EmployeeID'];
    modelNo = json['ModelNo'];
    assetNo = json['AssetNo'];
    iMEINo = json['IMEINo'];
    assetDate = json['AssetDate'];
    assetType = json['AssetType'];
    projectID = json['ProjectID'];
    projectName = json['ProjectName'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['AssetID'] = this.assetID;
    data['AssetName'] = this.assetName;
    data['AssetNote'] = this.assetNote;
    data['CreatedEmployee'] = this.createdEmployee;
    data['CreatedDesignation'] = this.createdDesignation;
    data['EmployeeName'] = this.employeeName;
    data['EmployeeID'] = this.employeeID;
    data['ModelNo'] = this.modelNo;
    data['AssetNo'] = this.assetNo;
    data['IMEINo'] = this.iMEINo;
    data['AssetDate'] = this.assetDate;
    data['AssetType'] = this.assetType;
    data['ProjectID'] = this.projectID;
    data['ProjectName'] = this.projectName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    return data;
  }
}
