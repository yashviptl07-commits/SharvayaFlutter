class MaterialOutwardModuleListRequest {
  String pkID;
  String SearchKey;
  String ModuleName;
  String DocName;
  String KeyValue;
  String LoginUserID;
  String CompanyId;

  MaterialOutwardModuleListRequest(
      {this.pkID,
      this.SearchKey,
      this.ModuleName,
      this.DocName,
      this.KeyValue,
      this.LoginUserID,
      this.CompanyId});

  MaterialOutwardModuleListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    SearchKey = json['SearchKey'];
    ModuleName = json['ModuleName'];
    DocName = json['DocName'];
    KeyValue = json['KeyValue'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['SearchKey'] = this.SearchKey;
    data['ModuleName'] = this.ModuleName;
    data['DocName'] = this.DocName;
    data['KeyValue'] = this.KeyValue;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
