/*"Module": "todo",
        "ParentID": 20444,
        "EmployeeID": 57,
        "LoginUserID": "admin",
        "CompanyId": 4132*/

class ModuleSharingSaveRequest {
  String Module;
  String ParentID;
  String EmployeeID;
  String LoginUserID;
  String CompanyId;


  ModuleSharingSaveRequest(
      {this.Module,
        this.ParentID,
        this.EmployeeID,
        this.LoginUserID,
        this.CompanyId,
      });


  ModuleSharingSaveRequest.fromJson(Map<String, dynamic> json) {
    Module = json['Module'];
    ParentID = json['ParentID'];
    EmployeeID = json['EmployeeID'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Module'] = this.Module;
    data['ParentID'] = this.ParentID;
    data['EmployeeID'] = this.EmployeeID;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
