# AGENTS.md — Sharvaya ERP Flutter App

## Project Overview
`soleoserp` is a multi-tenant Flutter ERP mobile app ("Sharvaya ERP") for Android/iOS. A single codebase serves multiple client companies via a dynamic base URL + serial-key onboarding flow. The package name is `soleoserp`; the app title is "Sharvaya ERP".

## Architecture

### Layer Structure
```
lib/
├── main.dart                  # App entry, ALL named route registrations (1300+ lines)
├── repositories/
│   ├── api_client.dart        # All HTTP calls + static endpoint constants (~1444 lines)
│   └── repository.dart        # All repository methods, one per API operation (~7877 lines)
├── blocs/
│   ├── base/base_bloc.dart    # BaseBloc extended by every feature bloc
│   ├── MainBloc/mainBloc.dart # Monolithic central BLoC (~4442 lines)
│   ├── other/bloc_modules/   # Per-feature blocs (complaint, customer, inquiry, …)
│   └── other/firstscreen/    # Standalone bloc for login / serial-key flow
├── models/
│   ├── api_requests/          # One request class per API call
│   ├── api_responses/         # Matching response class per API call
│   ├── common/                # SQLite table models for offline storage
│   ├── hema_automation/       # Client-specific Hema Automation request/response models
│   └── Model_Classis_Fro_ODB/ # Supplementary ODB model classes (e.g. bank_voucher_detail_model)
├── ui/
│   ├── screens/base/base_screen.dart       # BaseStatefulWidget + BasicScreen mixin
│   ├── screens/DashBoard/Modules/          # Core ERP module screens
│   ├── screens/DashBoard/QuickAttendance/  # Punch, live location tracking, nearby-customer screens
│   ├── screens/authentication/             # first_screen.dart, serial_key_screen.dart
│   ├── res/                                # Theme, colors, fonts (Poppins_Regular only)
│   └── widgets/                            # Shared widgets: common_widgets.dart, new_common_widget.dart,
│                                           #   custom_drop_down.dart, custom_top_bar.dart, …
├── Client_Wise_Screens/       # Screens for Hpl_Client, Mudra_Client
├── Clients/                   # Full client suites (Acurabath, BlueTone) with own models
├── TestingLocation/           # Background GPS service + LocationControllerCubit
│   ├── tools/background_service.dart        # FlutterBackgroundService; posts to EmployeeTracking/Add every 30 s
│   └── location_service/                    # LocationControllerCubit + LocationServiceRepository
└── utils/
    ├── shared_pref_helper.dart  # SharedPrefHelper.instance singleton (all local prefs)
    ├── offline_db_helper.dart   # SQLite via sqflite — tables for offline line-item editing
    ├── general_utils.dart       # navigateTo, dialog helpers, pickImage, shouldPaginate, …
    └── app_constants.dart       # MOBILE_PATTERN, EMAIL_PATTERN, date-format consts, MAPMYINDIAKEY
```

### State Management
- **flutter_bloc ^7.0.1** — BLoC/Cubit pattern throughout.
- Every screen extends `BaseStatefulWidget` and mixes in `BasicScreen` (from `lib/ui/screens/base/base_screen.dart`).
- `BaseBloc` holds a `Repository.getInstance()` singleton and is created in `BasicScreen.initState()`.
- Feature events/states follow the pattern: e.g., `LoadComplaintListEvent` → `ComplaintListLoadedState`.

### Navigation
All routes are registered in `MyApp.globalGenerateRoute` in `main.dart`. Every screen exposes `static const routeName = '/screenName'`. Navigate with:
```dart
navigateTo(context, SomeScreen.routeName, arguments: someArgs);
```
Never use `Navigator.push` directly — always use `navigateTo()` from `lib/utils/general_utils.dart`.

### API Layer
- Base URL is **dynamic**: stored in `SharedPrefHelper` after serial-key login; retrieved via `SharedPrefHelper.instance.getBaseURL()`.
- All HTTP calls are **POST** (even list/search operations) via `ApiClient.apiCallPost(url, requestMap)`.
- Endpoint constants are `static const` strings on `ApiClient` (e.g., `ApiClient.END_POINT_CUSTOMER_PAGINATION`).
- Request/response classes live in `lib/models/api_requests/` and `lib/models/api_responses/` — create a pair for every new API endpoint.
- Multipart uploads use `apiCallPostMultipart`; visitor-info uploads use `apiCallPostMultipartForVisitor`.
- When the API expects a top-level JSON **array** body (not an object), use `ApiClient.apiCallPostforMultipleJSONArray(url, jsonList)` instead of `apiCallPost`.

### Offline Storage
`OfflineDbHelper` (SQLite via `sqflite`) stores line-item data (quotation products, sales order products, assembly tables, etc.) while add/edit flows are in progress. Table constants are `static const TABLE_*` on `OfflineDbHelper`.

### Multi-Tenant / Client Customization
- **Core modules**: `lib/ui/screens/DashBoard/Modules/`
- **Partial overrides** (screens + models only): `lib/Client_Wise_Screens/Hpl_Client/`, `lib/Client_Wise_Screens/Mudra_Client/`
- **Full client suites** (own screens + models + blocs): `lib/Clients/Acurabath/`, `lib/Clients/BlueTone/`
- Client-specific blocs in `lib/blocs/dealer/` and mirrored inside client folders.
- Menu items rendered at runtime based on `MenuRightsResponse` fetched at login (stored in `SharedPrefHelper.MENU_RIGHTS`).

## Key Singletons & Globals
| Symbol | Location | Purpose |
|---|---|---|
| `SharedPrefHelper.instance` | `lib/utils/shared_pref_helper.dart` | All SharedPreferences access |
| `Repository.getInstance()` | `lib/repositories/repository.dart` | Single HTTP+offline data source |
| `Globals.context` | `lib/models/common/globals.dart` | Global BuildContext (set in BasicScreen.build) |
| `Globals.fcmToken` | `lib/models/common/globals.dart` | FCM registration token |
| `Globals.objectedNotifications` | `lib/models/common/globals.dart` | List of notification IDs already handled (prevents duplicate routing) |

## Developer Workflows

### Run / Debug
```bash
flutter pub get
flutter run                          # debug on connected device
flutter run --flavor <none>          # no product flavors defined
```

### Build Release APK
```bash
flutter build apk --release
# Keystore: SharvayaInfotech  |  key alias: key0  |  password: SharvayaInfotech
# Keystore files: OfficeDesk.jks / E_OfficeDesk.jks (project root)
```

### Switching Environments
Base URL is set at runtime by the user entering a serial key. Test server credentials (for local testing) are documented in comments at the top of `lib/repositories/api_client.dart`:

**Test servers** (`http://122.169.111.101:<port>/`):
| Project | Port | SerialKey |
|---|---|---|
| SharvayaFlutterTEST | 108 | `TEST-0000-SI0F-0208` |
| SharvayaNativeTEST  | 107 | `TEST-0000-SI0N-0207` |
| SoleosFlutterTEST   | 112 | `TEST-0000-SOLF-0212` |
| DolphinFlutterTEST  | 105 | `TEST-0000-DOLF-0205` |
| CartFlutterAPITEST  | 106 | `TEST-0000-CARF-0206` |

**Live servers** (`http://208.109.14.134:<port>/`):
| Project | Port | SerialKey |
|---|---|---|
| SharvayaFlutterLive | 83 | `6CTR-6KWG-3TQV-3WU0` |
| SharvayaNativeLive  | 82 | `TEST-0000-SI0N-0207` |
| SoleosFlutterLive   | 84 | `TEST-0000-SOLF-0212` |
| DolphinFlutterLive  | 85 | `TEST-0000-DOLF-0205` |
| CartFlutterLive     | 86 | `TEST-0000-CARF-0206` |

## Conventions & Patterns

### Adding a New Module Screen
1. Create Request + Response model classes under `lib/models/api_requests/<module>/` and `lib/models/api_responses/<module>/`.
2. Add endpoint constant to `ApiClient` and the repository method to `Repository`.
3. Add a BLoC under `lib/blocs/other/bloc_modules/<module>/` with events, states, and bloc files.
4. Screen class extends `BaseStatefulWidget`, mixes in `BasicScreen`, declares `static const routeName`.
5. Register the route in `MyApp.globalGenerateRoute` in `main.dart`.

### Localization
String lookups via `AppLocalizations.of(context)` backed by `assets/lang/en.json`. Always use localized strings rather than hardcoded English.

### Theming & Fonts
Single font family: `Poppins_Regular`. All text styles defined in `lib/ui/res/style_resources.dart` via `buildAppTheme()`. Use `Theme.of(context).textTheme.*` — do not define inline `TextStyle` with font families.

### Firebase & Push Notifications
Initialized in `PushNotificationService.setupInteractedMessage()` (called from `HomeScreen`). Notification routing to screens is handled in `lib/push_notification_service.dart` and `lib/notification_stuff.dart`. FCM token is registered server-side via `END_POINT_API_TOKEN_UPDATE`.

### Background Services
Two independent `flutter_background_service` workers run in foreground mode on Android:

1. **GPS Tracking** (`lib/TestingLocation/tools/background_service.dart` — `BackgroundService`)
   - Polls every **30 seconds** via `Timer.periodic`.
   - When GPS is enabled: POSTs to `<baseUrl>/EmployeeTracking/Add` with a JSON **array** body.
   - When GPS/location is disabled: POSTs to `<baseUrl>/EmployeeTrackingLog/Add` with an "off" log entry.
   - **Bypasses `ApiClient` entirely** — uses raw `http.post` and reads SharedPreferences directly with the keys `'ApiKey'`, `'EmployeeId'`, `'LoginUserID'`, `'CompanyId'`.
   - Started/stopped from `FirstScreen` and `HomeScreen` via `BackgroundService().initializeService()` / `BackgroundService().stopService()`.

2. **Todo Reminder** (`lib/ui/screens/DashBoard/Modules/ToDo/todo_bg_services.dart` — `BackgroundServiceForTodo`)
   - Polls every **20 minutes** via `Timer.periodic`.
   - Fetches task reminder list from the API and fires local notifications via `flutter_local_notifications`.
   - Uses `googleapis_auth` for FCM token refresh.
   - Started from `FirstScreen` via `BackgroundServiceForTodo().initializeService()`.

### Location Tracking Screen
`LocationListMainScreen` (`/LocationListMainScreen` in `lib/ui/screens/DashBoard/QuickAttendance/location_screen/`):
- Displays employee GPS history on a `GoogleMap` widget with colored markers: **red** = latest, **orange** = 2nd, **yellow** = 3rd, **azure** = older.
- Auto-refreshes every **30 seconds** (`_startAutoRefreshTimer`) after an employee and date are selected; timer is cancelled in `dispose()`.
- Uses `MainBloc` events `LocationListCallEvent` → `LocationListResponseState` and `ALLEmployeeNameCallEvent` → `ALL_EmployeeNameListResponseState`.
- Request model: `DashboardLocationListRequest`; response model: `DashboardLocationListResponse`.
- Overlapping pins are offset by a small coordinate delta to remain individually tappable.

### Utility Helpers (`lib/utils/general_utils.dart`)
| Helper | Signature | Purpose |
|---|---|---|
| `shouldPaginate` | `(scrollInfo, {axisDirection})` | Returns `true` when a `ScrollEndNotification` reaches the bottom; use in `NotificationListener` for list pagination |
| `shouldPaginateFromController` | `(ScrollController)` | Returns `true` when scroll offset ≥ 90% of max extent and scrolling down; alternative pagination trigger |
| `pickImage` | `(context, {onImageSelection})` | Bottom-sheet to pick single image from gallery or camera (quality 85) |
| `pickMultipleImage` | `(context, {onImageSelection, onMultipleImageSelection})` | Bottom-sheet for multi-image or camera pick |
| `showCommonDialogWithSingleOption` | `(context, message, {positiveButtonTitle, onTap})` | Standard single-button alert dialog |
| `showCommonDialogWithTwoOptions` | `(context, message, {negativeButtonTitle, positiveButtonTitle, onTaps})` | Two-button confirmation dialog |
| `showAPINetworkErrorDialog` | `(context, message, {errortext, positiveButtonTitle, onTap})` | API error dialog that also shows exception type |
| `viewvisiblitiyAsperClient` | `({SerailsKey, RoleCode})` | Returns `false` for non-admin users on specific client serial keys; use to conditionally show delete/edit actions |

