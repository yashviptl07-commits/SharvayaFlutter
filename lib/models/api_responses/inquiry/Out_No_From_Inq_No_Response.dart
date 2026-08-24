class OutNoFromInquiryNoResponse {
  List<OutNoFromInquiryNoResponseDetails> details;
  int totalCount;

  OutNoFromInquiryNoResponse({this.details, this.totalCount});

  OutNoFromInquiryNoResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new OutNoFromInquiryNoResponseDetails.fromJson(v));
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

class OutNoFromInquiryNoResponseDetails {
  int rowNum;
  int pkID;
  String quotationNo;
  String inquiryNo;

  OutNoFromInquiryNoResponseDetails({this.rowNum, this.pkID, this.quotationNo, this.inquiryNo});

  OutNoFromInquiryNoResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum']==null?0: json['RowNum'];
    pkID = json['pkID']==null?0: json['pkID'];
    quotationNo = json['QuotationNo']==null?"": json['QuotationNo'];
    inquiryNo = json['InquiryNo']==null?"": json['InquiryNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['QuotationNo'] = this.quotationNo;
    data['InquiryNo'] = this.inquiryNo;
    return data;
  }
}