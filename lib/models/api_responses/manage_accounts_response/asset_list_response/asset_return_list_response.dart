class AssetReturnListResponse {
  List<AssetReturnListResponseDetails> details;
  int totalCount;

  AssetReturnListResponse({this.details, this.totalCount});

  AssetReturnListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new AssetReturnListResponseDetails.fromJson(v));
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

class AssetReturnListResponseDetails {
  int rowNum;
  int pkID;
  int assetID;
  int employeeID;
  String employeeName;
  String modelNo;
  String iMEINo;
  String assetNo;
  String referenceNo;
  String assetNote;
  String assetDate;
  String assetType;
  int projectID;
  String projectName;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String assetName;

  AssetReturnListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.assetID,
      this.employeeID,
      this.employeeName,
      this.modelNo,
      this.iMEINo,
      this.assetNo,
      this.referenceNo,
      this.assetNote,
      this.assetDate,
      this.assetType,
      this.projectID,
      this.projectName,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.assetName});

  AssetReturnListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    assetID = json['AssetID'];
    employeeID = json['EmployeeID'];
    employeeName = json['EmployeeName'];
    modelNo = json['ModelNo'];
    iMEINo = json['IMEINo'];
    assetNo = json['AssetNo'];
    referenceNo = json['ReferenceNo'];
    assetNote = json['AssetNote'];
    assetDate = json['AssetDate'];
    assetType = json['AssetType'];
    projectID = json['ProjectID'];
    projectName = json['ProjectName'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    assetName = json['AssetName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['AssetID'] = this.assetID;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['ModelNo'] = this.modelNo;
    data['IMEINo'] = this.iMEINo;
    data['AssetNo'] = this.assetNo;
    data['ReferenceNo'] = this.referenceNo;
    data['AssetNote'] = this.assetNote;
    data['AssetDate'] = this.assetDate;
    data['AssetType'] = this.assetType;
    data['ProjectID'] = this.projectID;
    data['ProjectName'] = this.projectName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['AssetName'] = this.assetName;
    return data;
  }
}
