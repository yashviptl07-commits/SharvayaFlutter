class ToDoModuleSharingListResponse {
  List<ToDoModuleSharingListResponseDetails> details;
  int totalCount;

  ToDoModuleSharingListResponse({this.details, this.totalCount});

  ToDoModuleSharingListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ToDoModuleSharingListResponseDetails.fromJson(v));
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

class ToDoModuleSharingListResponseDetails {
  int pkID;
  String module;
  int parentID;
  int employeeID;
  String employeeName;
  String createdBy;
  String createdDate;

  ToDoModuleSharingListResponseDetails(
      {this.pkID,
        this.module,
        this.parentID,
        this.employeeID,
        this.employeeName,
        this.createdBy,
        this.createdDate});

  ToDoModuleSharingListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    module = json['Module'];
    parentID = json['ParentID'];
    employeeID = json['EmployeeID'];
    employeeName = json['EmployeeName'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['Module'] = this.module;
    data['ParentID'] = this.parentID;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}