class MudraProjectListResponse {
  List<Details> details;
  int totalCount;

  MudraProjectListResponse({this.details, this.totalCount});

  MudraProjectListResponse.fromJson(Map<String, dynamic> json) {
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
  int rowNum;
  int pkID;
  String productGroupName;
  bool activeFlag;
  String activeFlagDesc;

  Details(
      {this.rowNum,
        this.pkID,
        this.productGroupName,
        this.activeFlag,
        this.activeFlagDesc});

  Details.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    productGroupName = json['ProductGroupName'];
    activeFlag = json['ActiveFlag'];
    activeFlagDesc = json['ActiveFlagDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ProductGroupName'] = this.productGroupName;
    data['ActiveFlag'] = this.activeFlag;
    data['ActiveFlagDesc'] = this.activeFlagDesc;
    return data;
  }
}