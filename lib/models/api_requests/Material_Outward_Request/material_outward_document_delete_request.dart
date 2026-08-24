class MaterialOutwardDocumentDeleteRequest {
  String KeyValue;
  String ModuleName;
  String LoginUserID;
  String CompanyId;

  MaterialOutwardDocumentDeleteRequest({
    this.KeyValue,
    this.ModuleName,
    this.LoginUserID,
    this.CompanyId,
  });

  MaterialOutwardDocumentDeleteRequest.fromJson(Map<String, dynamic> json) {
    KeyValue = json['KeyValue'];
    ModuleName = json['ModuleName'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['KeyValue'] = this.KeyValue;
    data['ModuleName'] = this.ModuleName;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
