class ModulesDropDownListResponse {
  List<ModulesDropDownListResponseDetails> details;
  int totalCount;

  ModulesDropDownListResponse(
      {this.details, this.totalCount});

  ModulesDropDownListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ModulesDropDownListResponseDetails.fromJson(v));
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

class ModulesDropDownListResponseDetails {
  int pkID;
  int rowNum;
  String moduleName;
  String createdBy;
  String createdDate;

  ModulesDropDownListResponseDetails(
      {this.pkID,
        this.rowNum,
        this.moduleName,
        this.createdBy,
        this.createdDate});

  ModulesDropDownListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    rowNum = json['RowNum'];
    moduleName = json['ModuleName'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['RowNum'] = this.rowNum;
    data['ModuleName'] = this.moduleName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}