class MultiExpenseTypeListResponse {
  List<Details> details;
  int totalCount;

  MultiExpenseTypeListResponse({this.details, this.totalCount});

  MultiExpenseTypeListResponse.fromJson(Map<String, dynamic> json) {
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
  String expenseTypeName;
  bool isLocationRequired;

  Details(
      {this.rowNum, this.pkID, this.expenseTypeName, this.isLocationRequired});

  Details.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    expenseTypeName = json['ExpenseTypeName'];
    isLocationRequired = json['IsLocationRequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ExpenseTypeName'] = this.expenseTypeName;
    data['IsLocationRequired'] = this.isLocationRequired;
    return data;
  }
}
