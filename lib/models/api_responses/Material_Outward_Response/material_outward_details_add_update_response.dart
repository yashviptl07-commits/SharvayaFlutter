class MaterialOutwardDetailsAddUpdateResponse {
  List<MaterialOutwardDetailsAddUpdateResponseDetails> details;
  int totalCount;

  MaterialOutwardDetailsAddUpdateResponse({this.details, this.totalCount});

  MaterialOutwardDetailsAddUpdateResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(
            new MaterialOutwardDetailsAddUpdateResponseDetails.fromJson(v));
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

class MaterialOutwardDetailsAddUpdateResponseDetails {
  int column1;
  String column2;

  MaterialOutwardDetailsAddUpdateResponseDetails({this.column1, this.column2});

  MaterialOutwardDetailsAddUpdateResponseDetails.fromJson(
      Map<String, dynamic> json) {
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
