/*
pkID:0
InvoiceNo:RC-SHI-2526-0003
LoginUserID:admin
CompanyId:7313*/
class ShortInvoiceExportListRequest {
  String pkID;
  String InvoiceNo;
  String LoginUserID;
  String CompanyId;

  ShortInvoiceExportListRequest({
    this.pkID,
    this.InvoiceNo,
    this.LoginUserID,
    this.CompanyId,
  });

  ShortInvoiceExportListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    InvoiceNo = json['InvoiceNo'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['InvoiceNo'] = this.InvoiceNo;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
