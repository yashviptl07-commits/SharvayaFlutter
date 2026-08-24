/*
KeyValue:10017
ModuleName:SalesInvoice
LoginUserID:admin
CompanyId:7216*/
class InvoiceDocumentDeleteRequest {
  String KeyValue;
  String ModuleName;
  String LoginUserID;
  String CompanyId;

  InvoiceDocumentDeleteRequest({
    this.KeyValue,
    this.ModuleName,
    this.LoginUserID,
    this.CompanyId,
  });

  InvoiceDocumentDeleteRequest.fromJson(Map<String, dynamic> json) {
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
