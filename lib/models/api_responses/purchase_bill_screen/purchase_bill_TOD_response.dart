class PurchaseBillTODResponse {
  List<PurchaseBillTODResponseDetails> details;
  int totalCount;

  PurchaseBillTODResponse({this.details, this.totalCount});

  PurchaseBillTODResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new PurchaseBillTODResponseDetails.fromJson(v));
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

class PurchaseBillTODResponseDetails {
  int rowNum;
  int stateCode;
  String stateName;
  String countryCode;
  int gSTStateCode;

  PurchaseBillTODResponseDetails(
      {this.rowNum,
      this.stateCode,
      this.stateName,
      this.countryCode,
      this.gSTStateCode});

  PurchaseBillTODResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    stateCode = json['StateCode'];
    stateName = json['StateName'];
    countryCode = json['CountryCode'];
    gSTStateCode = json['GSTStateCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['StateCode'] = this.stateCode;
    data['StateName'] = this.stateName;
    data['CountryCode'] = this.countryCode;
    data['GSTStateCode'] = this.gSTStateCode;
    return data;
  }
}
