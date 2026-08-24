class ToDoEmployeeListSharingResponse {
  List<Details> details;
  int totalCount;

  ToDoEmployeeListSharingResponse({this.details, this.totalCount});

  ToDoEmployeeListSharingResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
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

class Details {
  int pkid;
  String module;
  int employeeID;
  String tokenNo;
  String employeeName;

  Details({this.pkid, this.module, this.employeeID, this.tokenNo, this.employeeName});

  Details.fromJson(Map<String, dynamic> json) {
    pkid = json['pkid'];
    module = json['Module'];
    employeeID = json['EmployeeID'];
    tokenNo = json['TokenNo'];
    employeeName = json['EmployeeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkid'] = this.pkid;
    data['Module'] = this.module;
    data['EmployeeID'] = this.employeeID;
    data['TokenNo'] = this.tokenNo;
    data['EmployeeName'] = this.employeeName;
    return data;
  }
}