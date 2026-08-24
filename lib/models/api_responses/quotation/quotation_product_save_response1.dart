class QuotationProductSaveResponse1 {
  List<QuotationProductSaveDetails1> details;
  int totalCount;

  QuotationProductSaveResponse1({this.details, this.totalCount});

  QuotationProductSaveResponse1.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new QuotationProductSaveDetails1.fromJson(v));
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

class QuotationProductSaveDetails1 {
  int column1;
  String column2;

  QuotationProductSaveDetails1({this.column1, this.column2});

  QuotationProductSaveDetails1.fromJson(Map<String, dynamic> json) {
    column1 = json['Column1'];
    column2 = json['Column2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    data['Column2'] = this.column2;
    return data;
  }
}
