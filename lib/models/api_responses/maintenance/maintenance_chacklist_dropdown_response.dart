class MaintenanceCheckListDRPResponse {
  List<Details> details;
  int totalCount;

  MaintenanceCheckListDRPResponse({this.details, this.totalCount});

  MaintenanceCheckListDRPResponse.fromJson(Map<String, dynamic> json) {
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
  int pkid;
  String checkHead;
  String checkDesc;

  Details({this.pkid, this.checkHead, this.checkDesc});

  Details.fromJson(Map<String, dynamic> json) {
    pkid = json['pkid'];
    checkHead = json['CheckHead'];
    checkDesc = json['CheckDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkid'] = this.pkid;
    data['CheckHead'] = this.checkHead;
    data['CheckDesc'] = this.checkDesc;
    return data;
  }
}