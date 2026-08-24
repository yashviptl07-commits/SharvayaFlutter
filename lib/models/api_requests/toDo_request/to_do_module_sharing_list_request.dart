/*Module:todo
ParentID:20444
CompanyId:4132*/



class ToDoModuleSharingListApiRequest {
  String Module;
  String ParentID;
  String CompanyId;


  ToDoModuleSharingListApiRequest({this.Module, this.ParentID, this.CompanyId});

  ToDoModuleSharingListApiRequest.fromJson(Map<String, dynamic> json) {
    Module = json['Module'];
    ParentID = json['ParentID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Module'] = this.Module;
    data['ParentID'] =this.ParentID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
