class ShortInvoiceCommonAddUpdateResponse {
  List<ShortInvoiceCommonAddUpdateResponseDetails> details;
  int totalCount;

  ShortInvoiceCommonAddUpdateResponse({this.details, this.totalCount});

  ShortInvoiceCommonAddUpdateResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ShortInvoiceCommonAddUpdateResponseDetails.fromJson(v));
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

class ShortInvoiceCommonAddUpdateResponseDetails {
  int column1;
  String column2;
  int column3;

  ShortInvoiceCommonAddUpdateResponseDetails(
      {this.column1, this.column2, this.column3});

  ShortInvoiceCommonAddUpdateResponseDetails.fromJson(Map<String, dynamic> json) {
    column1 = json['Column1'];
    column2 = json['Column2'];
    column3 = json['Column3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    data['Column2'] = this.column2;
    data['Column3'] = this.column3;
    return data;
  }
}
