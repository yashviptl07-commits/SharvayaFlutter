/*
FinishProductID:98
CompanyId:7313 */

class ShortInvoiceAssemblyLoadRequest {
  String FinishProductID;
  String CompanyId;

  ShortInvoiceAssemblyLoadRequest({
    this.FinishProductID,
    this.CompanyId,
  });

  ShortInvoiceAssemblyLoadRequest.fromJson(Map<String, dynamic> json) {
    FinishProductID = json['FinishProductID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FinishProductID'] = this.FinishProductID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
