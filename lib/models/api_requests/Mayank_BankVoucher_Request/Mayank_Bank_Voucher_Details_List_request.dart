/*
ParentID:10094
InvoiceNo:
LoginUserID:admin
CompanyId:4132*/
class MayankBankVoucherDetailsListRequest {
  int ParentID;
  String InvoiceNo;
  String LoginUserID;
  String CompanyId;

  MayankBankVoucherDetailsListRequest(
      {this.ParentID, this.InvoiceNo, this.LoginUserID, this.CompanyId});

  MayankBankVoucherDetailsListRequest.fromJson(Map<String, dynamic> json) {
    ParentID = json['ParentID'];
    InvoiceNo = json['InvoiceNo'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ParentID'] = this.ParentID;
    data['InvoiceNo'] = this.InvoiceNo;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
