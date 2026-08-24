class BulkAssignListRequest {
  String EmployeeID;
  String LeadIDs;
  String CompanyId;

  BulkAssignListRequest({this.EmployeeID, this.LeadIDs, this.CompanyId});

  BulkAssignListRequest.fromJson(Map<String, dynamic> json) {
    EmployeeID = json['EmployeeID'];
    LeadIDs = json['LeadIDs'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployeeID'] = this.EmployeeID;
    data['LeadIDs'] = this.LeadIDs;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
