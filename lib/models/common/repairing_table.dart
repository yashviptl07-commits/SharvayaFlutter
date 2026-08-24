/*
 pkID
 ParentID
 RepairingNo
 CheckListID
 CheckListName
 CheckFlag
 LoginUserID
 CompanyId
*/

class RepairingDetailsTable {
  int id;
  String pkID;
  String ParentID;
  String RepairingNo;
  String CheckListID;
  String CheckListName;
  String CheckFlag;
  String LoginUserID;
  String CompanyId;

  RepairingDetailsTable(
      this.pkID,
      this.ParentID,
      this.RepairingNo,
      this.CheckListID,
      this.CheckListName,
      this.CheckFlag,
      this.LoginUserID,
      this.CompanyId,
      {this.id}
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["pkID"] = this.pkID;
    data["ParentID"] = this.ParentID;
    data["RepairingNo"] = this.RepairingNo;
    data["CheckListID"] = this.CheckListID;
    data["CheckListName"] = this.CheckListName;
    data["CheckFlag"] = this.CheckFlag;
    data["LoginUserID"] = this.LoginUserID;
    data["CompanyId"] = this.CompanyId;

    return data;
  }

  @override
  String toString() {
    return 'RepairingDetailsTable{id: $id, pkID: $pkID, ParentID: $ParentID, RepairingNo: $RepairingNo, CheckListID: $CheckListID, CheckListName: $CheckListName, CheckFlag: $CheckFlag, LoginUserID: $LoginUserID, CompanyId: $CompanyId}';
  }

}
