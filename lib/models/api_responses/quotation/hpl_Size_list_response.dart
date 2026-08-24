class HplSizeListResponse {
  List<Details> details;
  int totalCount;

  HplSizeListResponse({this.details, this.totalCount});

  HplSizeListResponse.fromJson(Map<String, dynamic> json) {
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
  int pkID;
  int rowNum;
  String sizeName;
  String createdBy;
  String createdDate;

  Details(
      {this.pkID,
      this.rowNum,
      this.sizeName,
      this.createdBy,
      this.createdDate});

  Details.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    rowNum = json['RowNum'];
    sizeName = json['SizeName'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['RowNum'] = this.rowNum;
    data['SizeName'] = this.sizeName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
