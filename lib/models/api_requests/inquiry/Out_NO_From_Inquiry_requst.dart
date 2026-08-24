/*
InquiryNo:MAY23-008
CompanyId:4132*/
class OutNoFromInquiryNoRequest {
  String InquiryNo;
  String CompanyId;

  OutNoFromInquiryNoRequest({this.CompanyId, this.InquiryNo});

  OutNoFromInquiryNoRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    InquiryNo = json['InquiryNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['InquiryNo'] = this.InquiryNo;

    return data;
  }
}
