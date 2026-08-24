class MasterMaintenanceCheckListResponse {
  List<Details> details;
  int totalCount;

  MasterMaintenanceCheckListResponse({this.details, this.totalCount});

  MasterMaintenanceCheckListResponse.fromJson(Map<String, dynamic> json) {
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
  String contactPerson;

  Details({this.contactPerson});

  Details.fromJson(Map<String, dynamic> json) {
    contactPerson = json['ContactPerson'] == null ? "" : json['ContactPerson'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ContactPerson'] = this.contactPerson;
    return data;
  }
}