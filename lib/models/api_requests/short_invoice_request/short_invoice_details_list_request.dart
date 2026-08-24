class ShortInvoiceDetailsListRequest {
  String InvoiceNo;
  String CompanyId;

  ShortInvoiceDetailsListRequest({
    this.InvoiceNo,
    this.CompanyId,
  });

  ShortInvoiceDetailsListRequest.fromJson(Map<String, dynamic> json) {
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
