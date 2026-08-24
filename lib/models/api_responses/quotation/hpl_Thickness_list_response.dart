class HplThicknessListResponse {
  List<Details> details;
  int totalCount;

  HplThicknessListResponse({this.details, this.totalCount});

  HplThicknessListResponse.fromJson(Map<String, dynamic> json) {
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
  String thicknessName;
  String createdBy;
  String createdDate;

  Details(
      {this.pkID,
      this.rowNum,
      this.thicknessName,
      this.createdBy,
      this.createdDate});

  Details.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    rowNum = json['RowNum'];
    thicknessName = json['ThicknessName'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['RowNum'] = this.rowNum;
    data['ThicknessName'] = this.thicknessName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
