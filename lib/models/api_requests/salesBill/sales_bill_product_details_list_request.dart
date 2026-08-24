/*InvoiceNo:INV-2324-0003
CompanyId:4132*/

class SalesBillProductDetailsListRequest {
  String InvoiceNo;
  String CompanyId;

  SalesBillProductDetailsListRequest({this.InvoiceNo, this.CompanyId});

  SalesBillProductDetailsListRequest.fromJson(Map<String, dynamic> json) {
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
