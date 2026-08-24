class HplFinishListResponse {
  List<Details> details;
  int totalCount;

  HplFinishListResponse({this.details, this.totalCount});

  HplFinishListResponse.fromJson(Map<String, dynamic> json) {
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
  String finishName;
  String createdBy;
  String createdDate;

  Details(
      {this.pkID,
      this.rowNum,
      this.finishName,
      this.createdBy,
      this.createdDate});

  Details.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    rowNum = json['RowNum'];
    finishName = json['FinishName'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['RowNum'] = this.rowNum;
    data['FinishName'] = this.finishName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
