class PurchaseBillDetailsListRequest {
  String InvoiceNo;
  String CompanyId;

  PurchaseBillDetailsListRequest({
    this.InvoiceNo,
    this.CompanyId,
  });

  PurchaseBillDetailsListRequest.fromJson(Map<String, dynamic> json) {
    InvoiceNo = json['InvoiceNo'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InvoiceNo'] = this.InvoiceNo;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
