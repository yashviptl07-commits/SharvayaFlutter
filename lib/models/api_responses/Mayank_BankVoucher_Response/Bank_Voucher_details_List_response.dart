class MayankBankVoucherDetailsListResponse {
  List<MayankBankVoucherDetailsListDetails> details;
  int totalCount;

  MayankBankVoucherDetailsListResponse({this.details, this.totalCount});

  MayankBankVoucherDetailsListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MayankBankVoucherDetailsListDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class MayankBankVoucherDetailsListDetails {
  int pkID;
  String voucherType;
  String recPay;
  int parentID;
  String invoiceNo;
  double amount;
  int accountID;
  String accountName;
  int customerID;
  String customerName;
  String createdDate;
  String createdBy;
  String updatedDate;
  String updatedBy;

  MayankBankVoucherDetailsListDetails(
      {this.pkID,
      this.voucherType,
      this.recPay,
      this.parentID,
      this.invoiceNo,
      this.amount,
      this.accountID,
      this.accountName,
      this.customerID,
      this.customerName,
      this.createdDate,
      this.createdBy,
      this.updatedDate,
      this.updatedBy});

  MayankBankVoucherDetailsListDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    voucherType = json['VoucherType'];
    recPay = json['RecPay'];
    parentID = json['ParentID'];
    invoiceNo = json['InvoiceNo'];
    amount = json['Amount'];
    accountID = json['AccountID'];
    accountName = json['AccountName'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'];
    createdDate = json['CreatedDate'];
    createdBy = json['CreatedBy'];
    updatedDate = json['UpdatedDate'];
    updatedBy = json['UpdatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['VoucherType'] = this.voucherType;
    data['RecPay'] = this.recPay;
    data['ParentID'] = this.parentID;
    data['InvoiceNo'] = this.invoiceNo;
    data['Amount'] = this.amount;
    data['AccountID'] = this.accountID;
    data['AccountName'] = this.accountName;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['CreatedDate'] = this.createdDate;
    data['CreatedBy'] = this.createdBy;
    data['UpdatedDate'] = this.updatedDate;
    data['UpdatedBy'] = this.updatedBy;
    return data;
  }
}
