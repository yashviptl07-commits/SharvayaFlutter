class MayankBankVoucherInqNoResponse {
  List<Details> details;
  int totalCount;

  MayankBankVoucherInqNoResponse({this.details, this.totalCount});

  MayankBankVoucherInqNoResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
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

class Details {
  String invoiceNo;

  Details({this.invoiceNo});

  Details.fromJson(Map<String, dynamic> json) {
    invoiceNo = json['InvoiceNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InvoiceNo'] = this.invoiceNo;
    return data;
  }
}
