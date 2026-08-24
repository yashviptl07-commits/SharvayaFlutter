class WorkNotesTable {
  int id;
  String pkID;
  String SrNo;
  String ServiceNo;
  String WorkNotes;
  String LoginUserID;
  String CompanyId;

  WorkNotesTable(this.pkID, this.SrNo, this.ServiceNo, this.WorkNotes,
      this.LoginUserID, this.CompanyId,
      {this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['SrNo'] = this.SrNo;
    data['ServiceNo'] = this.ServiceNo;
    data['WorkNotes'] = this.WorkNotes;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }

  @override
  String toString() {
    return 'WorkNotesTable{id: $id, pkID: $pkID, SrNo: $SrNo, ServiceNo: $ServiceNo, WorkNotes: $WorkNotes, LoginUserID: $LoginUserID, CompanyId: $CompanyId}';
  }
}
