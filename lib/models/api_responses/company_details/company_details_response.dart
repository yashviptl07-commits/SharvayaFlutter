class CompanyDetailsResponse {
  List<CompanyProfile> details;
  int totalCount;

  CompanyDetailsResponse({this.details, this.totalCount});

  CompanyDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new CompanyProfile.fromJson(v));
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

class CompanyProfile {
  int pkId;
  String companyName;
  int NoOfUsers;
  String SerialKey;
  String WebAPIServerIP;
  String baseURL;
  String baseURL2;
  String DBIP;
  String DBName;
  String DBUsername;
  String DBPassword;
  String InstallationDate;
  String ExpiryDate;
  String RootPath;
  String siteURL;
  String IndiaMartKey;
  String IndiaMartMobile;
  String IndiaMartAcAlias;
  String IndiaMartKey2;
  String IndiaMartMobile2;
  String IndiaMartAcAlias2;
  String mobileAppVersion;
  int PortNo;
  bool ISAMC;
  bool ReminderNotification;
  bool AMCEmailNotificationReminder;
  bool PaymentEmailNotificationReminder;
  bool EmailCampaign;
  String AndroidApp;
  String IOSApp;
  String MapApiKey;
  bool IsCampaign;
  bool LiveLocationFlag;

  CompanyProfile(
      {this.pkId,
      this.companyName,
      this.NoOfUsers,
      this.SerialKey,
      this.WebAPIServerIP,
      this.baseURL,
      this.baseURL2,
      this.DBIP,
      this.DBName,
      this.DBUsername,
      this.DBPassword,
      this.InstallationDate,
      this.ExpiryDate,
      this.RootPath,
      this.siteURL,
      this.IndiaMartKey,
      this.IndiaMartMobile,
      this.IndiaMartAcAlias,
      this.IndiaMartKey2,
      this.IndiaMartMobile2,
      this.IndiaMartAcAlias2,
      this.mobileAppVersion,
      this.PortNo,
      this.ISAMC,
      this.ReminderNotification,
      this.AMCEmailNotificationReminder,
      this.PaymentEmailNotificationReminder,
      this.EmailCampaign,
      this.AndroidApp,
      this.IOSApp,
      this.MapApiKey,
      this.IsCampaign,
      this.LiveLocationFlag});

  CompanyProfile.fromJson(Map<String, dynamic> json) {
    pkId = json['pkId'] == null ? 0 : json['pkId'];
    companyName = json['CompanyName'] == null ? "" : json['CompanyName'];
    NoOfUsers = json['NoOfUsers'] == null ? 0 : json['NoOfUsers'];
    SerialKey = json['SerialKey'] == null ? "" : json['SerialKey'];
    WebAPIServerIP =
        json['WebAPIServerIP'] == null ? "" : json['WebAPIServerIP'];
    baseURL = json['BaseURL'] == null ? "" : json['BaseURL'];
    baseURL2 = json['BaseURL2'] == null ? "" : json['BaseURL2'];
    DBIP = json['DBIP'] == null ? "" : json['DBIP'];
    DBName = json['DBName'] == null ? "" : json['DBName'];
    DBUsername = json['DBUsername'] == null ? "" : json['DBUsername'];
    DBPassword = json['DBPassword'] == null ? "" : json['DBPassword'];
    InstallationDate =
        json['InstallationDate'] == null ? "" : json['InstallationDate'];
    ExpiryDate = json['ExpiryDate'] == null ? "" : json['ExpiryDate'];
    RootPath = json['RootPath'] == null ? "" : json['RootPath'];
    siteURL = json['SiteURL'] == null ? "" : json['SiteURL'];
    IndiaMartKey = json['IndiaMartKey'] == null ? "" : json['IndiaMartKey'];
    IndiaMartMobile =
        json['IndiaMartMobile'] == null ? "" : json['IndiaMartMobile'];
    IndiaMartAcAlias =
        json['IndiaMartAcAlias'] == null ? "" : json['IndiaMartAcAlias'];
    IndiaMartKey2 = json['IndiaMartKey2'] == null ? "" : json['IndiaMartKey2'];
    IndiaMartMobile2 =
        json['IndiaMartMobile2'] == null ? "" : json['IndiaMartMobile2'];
    IndiaMartAcAlias2 =
        json['IndiaMartAcAlias2'] == null ? "" : json['IndiaMartAcAlias2'];
    mobileAppVersion =
        json['MobileAppVersion'] == null ? "" : json['MobileAppVersion'];
    PortNo = json['PortNo'] == null ? 0 : json['PortNo'];
    ISAMC = json['ISAMC'] == null ? false : json['ISAMC'];
    ReminderNotification = json['ReminderNotification'] == null
        ? false
        : json['ReminderNotification'];
    AMCEmailNotificationReminder = json['AMCEmailNotificationReminder'] == null
        ? false
        : json['AMCEmailNotificationReminder'];
    PaymentEmailNotificationReminder =
        json['PaymentEmailNotificationReminder'] == null
            ? false
            : json['PaymentEmailNotificationReminder'];
    EmailCampaign =
        json['EmailCampaign'] == null ? false : json['EmailCampaign'];
    AndroidApp = json['AndroidApp'] == null ? "" : json['AndroidApp'];
    IOSApp = json['IOSApp'] == null ? "" : json['IOSApp'];
    MapApiKey = json['MapApiKey'] == null ? "" : json['MapApiKey'];
    IsCampaign = json['IsCampaign'] == null ? false : json['IsCampaign'];
    LiveLocationFlag =
        json['LiveLocationFlag'] == null ? false : json['LiveLocationFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkId'] = this.pkId;
    data['CompanyName'] = this.companyName;
    data['NoOfUsers'] = this.NoOfUsers;
    data['SerialKey'] = this.SerialKey;
    data['WebAPIServerIP'] = this.WebAPIServerIP;
    data['BaseURL'] = this.baseURL;
    data['BaseURL2'] = this.baseURL2;
    data['DBIP'] = this.DBIP;
    data['DBName'] = this.DBName;
    data['DBUsername'] = this.DBUsername;
    data['DBPassword'] = this.DBPassword;
    data['InstallationDate'] = this.InstallationDate;
    data['ExpiryDate'] = this.ExpiryDate;
    data['RootPath'] = this.RootPath;
    data['SiteURL'] = this.siteURL;
    data['IndiaMartKey'] = this.IndiaMartKey;
    data['IndiaMartMobile'] = this.IndiaMartMobile;
    data['IndiaMartAcAlias'] = this.IndiaMartAcAlias;
    data['IndiaMartKey2'] = this.IndiaMartKey2;
    data['IndiaMartMobile2'] = this.IndiaMartMobile2;
    data['IndiaMartAcAlias2'] = this.IndiaMartAcAlias2;
    data['MobileAppVersion'] = this.mobileAppVersion;
    data['PortNo'] = this.PortNo;
    data['ISAMC'] = this.ISAMC;
    data['ReminderNotification'] = this.ReminderNotification;
    data['AMCEmailNotificationReminder'] = this.AMCEmailNotificationReminder;
    data['PaymentEmailNotificationReminder'] =
        this.PaymentEmailNotificationReminder;
    data['EmailCampaign'] = this.EmailCampaign;
    data['AndroidApp'] = this.AndroidApp;
    data['IOSApp'] = this.IOSApp;
    data['MapApiKey'] = this.MapApiKey;
    data['IsCampaign'] = this.IsCampaign;
    data['LiveLocationFlag'] = this.LiveLocationFlag;
    return data;
  }
}
