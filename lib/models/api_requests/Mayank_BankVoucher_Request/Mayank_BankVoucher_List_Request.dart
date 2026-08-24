/*
pkID       :0
SearchKey  :
TrType     :bank
PageNo     :1
PageSize   :10
LoginUserID:admin
CompanyId  :4132*/

class MayankBankVoucherListRequest {
  int pkID;
  String SearchKey;
  String TrType;
  int PageNo;
  int PageSize;
  String LoginUserID;
  int CompanyId;

  MayankBankVoucherListRequest(
      {this.pkID,
      this.SearchKey,
      this.TrType,
      this.PageNo,
      this.PageSize,
      this.LoginUserID,
      this.CompanyId});

  MayankBankVoucherListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    SearchKey = json['SearchKey'];
    TrType = json['TrType'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['SearchKey'] = this.SearchKey;
    data['TrType'] = this.TrType;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
