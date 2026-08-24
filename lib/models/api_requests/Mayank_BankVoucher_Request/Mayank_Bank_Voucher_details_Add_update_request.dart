/*
pkID:10014
ParentID:10094
InvoiceNo:INV-2324-0008
Amount:1600.00
LoginUserID:admin
CompanyId:4132*/
class MayankBankVoucherDetailsAddEditRequest {
  String pkID;
  String ParentID;
  String InvoiceNo;
  String Amount;
  String LoginUserID;
  String CompanyId;

  MayankBankVoucherDetailsAddEditRequest(
      {this.pkID,
      this.ParentID,
      this.InvoiceNo,
      this.Amount,
      this.LoginUserID,
      this.CompanyId});

  MayankBankVoucherDetailsAddEditRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ParentID = json['ParentID'];
    InvoiceNo = json['InvoiceNo'];
    Amount = json['Amount'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ParentID'] = this.ParentID;
    data['InvoiceNo'] = this.InvoiceNo;
    data['Amount'] = this.Amount;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
