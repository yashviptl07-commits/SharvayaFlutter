class SharvayaDailyActivityListResponse {
  List<SharvayaDailyActivityListResponseDetails> details;
  int totalCount;
  String totalDuration;

  SharvayaDailyActivityListResponse({this.details, this.totalCount, this.totalDuration});

  SharvayaDailyActivityListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new SharvayaDailyActivityListResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
    totalDuration = json['TotalDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    data['TotalDuration'] = this.totalDuration;
    return data;
  }
}

class SharvayaDailyActivityListResponseDetails {
  dynamic rowNum;
  dynamic pkID;
  String activityDate;
  String taskDescription;
  dynamic taskCategoryID;
  String taskCategory;
  dynamic taskDuration;
  String createdBy;
  String createdDate;
  dynamic updatedBy;
  String updatedDate;
  dynamic taskpkID;
  dynamic toDOID;
  dynamic customerID;
  String customerName;
  dynamic estHours;
  String employeeName;
  dynamic employeeID;
  int moduleID;
  String moduleName;

  SharvayaDailyActivityListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.activityDate,
      this.taskDescription,
      this.taskCategoryID,
      this.taskCategory,
      this.taskDuration,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.taskpkID,
      this.toDOID,
      this.customerID,
      this.customerName,
      this.employeeName,
      this.employeeID,
      this.estHours,
      this.moduleID,
      this.moduleName,
      });

  SharvayaDailyActivityListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    activityDate = json['ActivityDate'] == null ? "" : json['ActivityDate'];
    taskDescription =
        json['TaskDescription'] == null ? "" : json['TaskDescription'];
    taskCategoryID =
        json['TaskCategoryID'] == null ? 0 : json['TaskCategoryID'];
    taskCategory = json['TaskCategory'] == null ? "" : json['TaskCategory'];
    taskDuration = json['TaskDuration'] == null ? 0 : json['TaskDuration'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    updatedBy = json['UpdatedBy'] == null ? 0 : json['UpdatedBy'];
    updatedDate = json['UpdatedDate'] == null ? "" : json['UpdatedDate'];
    taskpkID = json['TaskpkID'] == null ? 0 : json['TaskpkID'];
    toDOID = json['ToDOID'] == null ? 0 : json['ToDOID'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    employeeName = json['EmployeeName'] == null ? "" : json['EmployeeName'];
    employeeID = json['EmployeeID'] == null ? 0 : json['EmployeeID'];
    estHours = json['EstHours'] == null ? 0 : json['EstHours'];
    moduleID = json['ModuleID'] == null ? 0 : json['ModuleID'];
    moduleName = json['ModuleName'] == null ? "" : json['ModuleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ActivityDate'] = this.activityDate;
    data['TaskDescription'] = this.taskDescription;
    data['TaskCategoryID'] = this.taskCategoryID;
    data['TaskCategory'] = this.taskCategory;
    data['TaskDuration'] = this.taskDuration;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['TaskpkID'] = this.taskpkID;
    data['ToDOID'] = this.toDOID;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['EstHours'] = this.estHours;
    data['EmployeeName'] = this.employeeName;
    data['EmployeeID'] = this.employeeID;
    data['ModuleID'] = this.moduleID;
    data['ModuleName'] = this.moduleName;
    return data;
  }
}
