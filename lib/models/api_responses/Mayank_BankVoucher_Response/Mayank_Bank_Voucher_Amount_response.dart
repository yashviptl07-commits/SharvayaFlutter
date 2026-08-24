class MayankBankVoucherAmountResponse {
  List<Details> details;
  int totalCount;

  MayankBankVoucherAmountResponse({this.details, this.totalCount});

  MayankBankVoucherAmountResponse.fromJson(Map<String, dynamic> json) {
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
  double invoiceAmount;
  String invoiceNo;

  Details({this.invoiceAmount, this.invoiceNo});

  Details.fromJson(Map<String, dynamic> json) {
    invoiceAmount = json['InvoiceAmount'] == null ? 0 : json['InvoiceAmount'];
    invoiceNo = json['InvoiceNo'] == null ? "" : json['InvoiceNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InvoiceAmount'] = this.invoiceAmount;
    data['InvoiceNo'] = this.invoiceNo;
    return data;
  }
}
