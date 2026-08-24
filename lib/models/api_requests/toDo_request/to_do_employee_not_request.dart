class ToDoEmployeeListSharingRequest {
  String ParentID;
  String Status;
  String LoginUserID;
  String CompanyId;

  ToDoEmployeeListSharingRequest({this.ParentID,this.Status,this.LoginUserID,this.CompanyId});

  ToDoEmployeeListSharingRequest.fromJson(Map<String, dynamic> json) {
    ParentID = json['ParentID'];
    Status = json['Status'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ParentID'] = this.ParentID;
    data['Status'] = this.Status;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}