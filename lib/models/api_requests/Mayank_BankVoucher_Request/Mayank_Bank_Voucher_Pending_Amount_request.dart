/*
InvoiceNo:INV-2324-0008
Mode:sales
LoginUserID:admin
CompanyId:4132*/
class MayankBankVoucherAmountRequest {
  String InvoiceNo;
  String Mode;
  String LoginUserID;
  int CompanyId;

  MayankBankVoucherAmountRequest(
      {this.InvoiceNo, this.Mode, this.LoginUserID, this.CompanyId});

  MayankBankVoucherAmountRequest.fromJson(Map<String, dynamic> json) {
    Mode = json['Mode'];
    InvoiceNo = json['InvoiceNo'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InvoiceNo'] = this.InvoiceNo;
    data['Mode'] = this.Mode;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
