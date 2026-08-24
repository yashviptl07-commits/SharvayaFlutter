class MasterMaintenanceCheckListResponse1 {
  List<Details> details;
  int totalCount;

  MasterMaintenanceCheckListResponse1({this.details, this.totalCount});

  MasterMaintenanceCheckListResponse1.fromJson(Map<String, dynamic> json) {
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
  String contactNumber;

  Details({this.contactNumber});

  Details.fromJson(Map<String, dynamic> json) {
    contactNumber = json['ContactNumber'] == null ? "" : json['ContactNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ContactNumber'] = this.contactNumber;
    return data;
  }
}