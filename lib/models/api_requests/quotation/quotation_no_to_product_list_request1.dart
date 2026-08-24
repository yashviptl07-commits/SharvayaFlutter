/*
CompanyId:10032
InquiryNo:DEC21-003*/
class QuotationNoToProductListRequest1 {
  String QuotationNo;
  String CompanyId;

  QuotationNoToProductListRequest1({this.QuotationNo, this.CompanyId});

  QuotationNoToProductListRequest1.fromJson(Map<String, dynamic> json) {
    QuotationNo = json['QuotationNo'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QuotationNo'] = this.QuotationNo;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
