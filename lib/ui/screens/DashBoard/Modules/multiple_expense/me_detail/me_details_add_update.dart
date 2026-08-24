import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multiple_expense_expenseType_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/multiple_expense_table.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_filds.dart';
import 'package:soleoserp/utils/image_full_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class MultiExpenseDetailsAddEditScreenArguments {
  final MultipleExpenseTable model;
  MultiExpenseDetailsAddEditScreenArguments(this.model);
}

class MultiExpenseDetailsAddEditScreen extends BaseStatefulWidget {
  static const routeName = 'MultiExpenseDetailsAddEditScreen';

  final MultiExpenseDetailsAddEditScreenArguments arguments;
  MultiExpenseDetailsAddEditScreen(this.arguments);

  @override
  _MultiExpenseDetailsAddEditScreenState createState() =>
      _MultiExpenseDetailsAddEditScreenState();
}

class _MultiExpenseDetailsAddEditScreenState
    extends BaseState<MultiExpenseDetailsAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  MainBloc _mainBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";

  final TextEditingController _amountController = TextEditingController();

  final TextEditingController _fromLocationController = TextEditingController();
  final TextEditingController _toLocationController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController edt_expensetypeIdController =
      TextEditingController();
  final TextEditingController edt_expensetypeNameController =
      TextEditingController();
  final TextEditingController edt_expenseModeIdController =
      TextEditingController();
  final TextEditingController edt_expenseModeNameController =
      TextEditingController();
  final TextEditingController edt_expenseDate = TextEditingController();
  final TextEditingController edt_ReverseexpenseDate = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_expenseType = [];

  // Kept as String internally so BOTH cases work on this page:
  //  - a freshly picked local file (image/pdf) -> local path
  //  - an already-uploaded voucher coming back from server -> full URL
  //    e.g. http://122.172.240.149:133/otherImages/SwiftProgramming1.0.pdf
  // model.Voucher itself is still a File (unchanged) — conversion to/from
  // File happens only at the two boundary points: initState() (File -> String)
  // and _save() (String -> File), so nothing outside this page is affected.
  String _voucherPath;
  String _voucherFileName = "";
  bool _isVoucherPdf = false;
  int _id;
  String pkID = "";
  Function onTapOfBack;

  bool get _isRemoteVoucher =>
      _voucherPath != null &&
      (_voucherPath.startsWith('http://') ||
          _voucherPath.startsWith('https://'));

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _mainBloc = MainBloc(baseBloc);

    final model = widget.arguments.model;
    if (model != null) {
      _id = model.id;
      pkID = model.pkID ?? "";
      edt_expensetypeIdController.text = model.ExpenseTypeId ?? "";
      _amountController.text = model.Amount ?? "";

      _fromLocationController.text = model.FromLocation ?? "";
      _toLocationController.text = model.ToLocation ?? "";

      _remarksController.text = model.Remarks ?? "";
      edt_expensetypeNameController.text = model.ExpenseTypeName ?? "";
      edt_expenseDate.text = model.ExpenseDateDetail.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_ReverseexpenseDate.text = model.ExpenseDateDetail.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

      // model.Voucher is a File; its .path can hold either a local file path
      // or (in the update-from-server case) a full http(s) URL string.
      if (model.Voucher != null &&
          model.Voucher.path != null &&
          model.Voucher.path.trim().isNotEmpty) {
        _voucherPath = model.Voucher.path.trim();
        _voucherFileName =
            _voucherPath.split(RegExp(r'[\\/]')).last; // works for both
        _isVoucherPdf = _voucherFileName.toLowerCase().trim().endsWith(".pdf");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is MultiExpenseTypeListResponseState) {
            _onMultiExpenseTypeListResponseStateCallSuccess(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MultiExpenseTypeListResponseState) {
            return true;
          }

          return false;
        },
      ),
    );
  }

  Future<void> _pickVoucherImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        _setVoucherFile(picked.path, picked.name);
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  Future<void> _pickVoucherPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null &&
          result.files.isNotEmpty &&
          result.files.single.path != null) {
        final path = result.files.single.path;
        final name =
            result.files.single.name ?? path.split(Platform.pathSeparator).last;
        _setVoucherFile(path, name);
      }
    } catch (e) {
      debugPrint("PDF pick error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not pick PDF, please try again")),
        );
      }
    }
  }

  void _setVoucherFile(String path, String fileName) {
    setState(() {
      _voucherPath = path;
      _voucherFileName = fileName;
      _isVoucherPdf = fileName.toLowerCase().trim().endsWith('.pdf') ||
          path.toLowerCase().trim().endsWith('.pdf');
    });
  }

  void _removeVoucherFile() {
    setState(() {
      _voucherPath = null;
      _voucherFileName = "";
      _isVoucherPdf = false;
    });
  }

  // Opens the voucher file — local PDF via the device's PDF viewer app,
  // remote PDF (already-uploaded URL) via the browser / external app.
  Future<void> _openVoucher(String path) async {
    if (path == null || path.isEmpty) return;
    try {
      if (path.startsWith('http://') || path.startsWith('https://')) {
        final uri = Uri.parse(path);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          _showOpenVoucherError();
        }
      } else {
        final result = await OpenFile.open(path);
        if (result.type != ResultType.done) {
          _showOpenVoucherError();
        }
      }
    } catch (e) {
      debugPrint("Open voucher error: $e");
      _showOpenVoucherError();
    }
  }

  void _showOpenVoucherError() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open the file")),
      );
    }
  }

  Widget _buildVoucherPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap:
                      _isVoucherPdf ? () => _openVoucher(_voucherPath) : null,
                  child: Row(
                    children: [
                      Icon(
                        _isVoucherPdf ? Icons.picture_as_pdf : Icons.image,
                        color: colorPrimary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _isVoucherPdf
                              ? 'PDF Attached (tap to open)'
                              : 'Image Attached',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: _removeVoucherFile,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(Icons.close, size: 18, color: Colors.red.shade400),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _voucherFileName.isNotEmpty
                ? _voucherFileName
                : (_voucherPath ?? ""),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            overflow: TextOverflow.ellipsis,
          ),
          if (!_isVoucherPdf && _voucherPath != null) ...[
            const SizedBox(height: 8),
            ImageFullScreenWrapperWidget(
              dark: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _isRemoteVoucher
                    ? Image.network(
                        _voucherPath,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            height: 120,
                            width: 120,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint("Voucher network image error: $error");
                          return Container(
                            height: 120,
                            width: 120,
                            color: Colors.grey.shade200,
                            child: Icon(Icons.broken_image,
                                color: Colors.grey.shade500),
                          );
                        },
                      )
                    : Image.file(
                        File(_voucherPath),
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint("Voucher local image error: $error");
                          return Container(
                            height: 120,
                            width: 120,
                            color: Colors.grey.shade200,
                            child: Icon(Icons.broken_image,
                                color: Colors.grey.shade500),
                          );
                        },
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (edt_ReverseexpenseDate.text != "") {
      if (_amountController.text != "") {
        if (_formKey.currentState.validate()) {
          final model = MultipleExpenseTable(
            pkID,
            "",
            edt_expensetypeIdController.text,
            _amountController.text,
            _remarksController.text,
            _toLocationController.text,
            _fromLocationController.text,
            // model.Voucher is a File — converted here from our internal
            // String (local path or remote url). File() just wraps the
            // string; it doesn't need the path to exist locally, so a
            // remote URL round-trips fine through the local table too.
            _voucherPath != null ? File(_voucherPath) : null,
            edt_ReverseexpenseDate.text,
            LoginUserID,
            CompanyID.toString(),
            edt_expensetypeNameController.text,
          );
          if (_id == null) {
            await OfflineDbHelper.getInstance().insertMultipleExpense(model);
          } else {
            model.id = _id;
            // persists whatever _voucherPath currently holds (kept remote
            // url if untouched, or new local path if user picked a new
            // file) into the local table so re-opening this screen shows
            // it correctly next time.
            await OfflineDbHelper.getInstance().updateMultipleExpense(model);
          }
          Navigator.of(context).pop(true);
        }
      } else {
        showCommonDialogWithSingleOption(context, "Amount Is Required !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      }
    } else {
      showCommonDialogWithSingleOption(context, "Date Is Required !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        title:
            Text(_id == null ? "Add Expense Details" : "Edit Expense Details"),
        gradient: LinearGradient(colors: [
          Color(0xff108dcf),
          Color(0xff0066b3),
          Color(0xff108dcf),
        ]),
        leading: InkWell(
            onTap: () {
              if (onTapOfBack == null) {
                Navigator.of(context).pop();
              } else {
                onTapOfBack();
              }
            },
            child: Icon(Icons.arrow_back_outlined)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ClaimDate(),
              SizedBox(height: 10),
              buildCommonDropDown(
                label: "Expense Type",
                context: context,
                nameController: edt_expensetypeNameController,
                idController: edt_expensetypeIdController,
                hintText: "--- Select ---",
                CommonList: arr_ALL_Name_ID_For_expenseType,
                onTap: () {
                  _mainBloc.add(MultiExpenseTypeListRequestEvent(
                      MultiExpenseTypeListRequest(
                    pkID: "0",
                    ListMode: "",
                    LoginUserID: LoginUserID,
                    SearchKey: "",
                    PageNo: "1",
                    PageSize: "10000000",
                    CompanyId: CompanyID.toString(),
                  )));
                },
              ),
              SizedBox(height: 10),
              buildTextField(
                label: "From Location",
                hint: "Enter From Location",
                controller: _fromLocationController,
                context: context,
              ),
              SizedBox(height: 10),
              buildTextField(
                label: "To Location",
                hint: "Enter To Location",
                controller: _toLocationController,
                context: context,
              ),
              SizedBox(height: 10),
              buildTextField(
                label: "Amount",
                hint: "Enter Amount",
                controller: _amountController,
                context: context,
              ),
              SizedBox(height: 10),
              buildTextFieldForLargeBox(
                label: "Remark",
                hintText: "Enter remark",
                controller: _remarksController,
                context: context,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickVoucherImage,
                      icon: Icon(Icons.image_outlined,
                          color: colorPrimary, size: 20),
                      label: Text(
                        "Attach Image",
                        style: TextStyle(
                            color: colorPrimary, fontWeight: FontWeight.w500),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: colorPrimary, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickVoucherPdf,
                      icon: Icon(Icons.picture_as_pdf_outlined,
                          color: colorPrimary, size: 20),
                      label: Text(
                        "Attach PDF",
                        style: TextStyle(
                            color: colorPrimary, fontWeight: FontWeight.w500),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: colorPrimary, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_voucherPath != null) ...[
                const SizedBox(height: 8),
                _buildVoucherPreview(),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text("Save", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onMultiExpenseTypeListResponseStateCallSuccess(
      MultiExpenseTypeListResponseState state) {
    arr_ALL_Name_ID_For_expenseType.clear();

    if (state.multiExpenseTypeListResponse.details.isNotEmpty) {
      for (var item in state.multiExpenseTypeListResponse.details) {
        arr_ALL_Name_ID_For_expenseType.add(
          ALL_Name_ID()
            ..Name = item.expenseTypeName
            ..pkID = item.pkID,
        );
      }

      showCustomDialog(
        context: context,
        label: "Select Expense Type",
        values: arr_ALL_Name_ID_For_expenseType,
        nameController: edt_expensetypeNameController,
        idController: edt_expensetypeIdController,
        onSelected: (name, id) {
          setState(() {
            edt_expensetypeNameController.text = name;
            edt_expensetypeIdController.text = id;
          });
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No ExpenseType")),
      );
    }
  }

  void showCustomDialog({
    BuildContext context,
    String label,
    List<ALL_Name_ID> values,
    TextEditingController nameController,
    TextEditingController idController,
    IconData icon = Icons.person,
    Function(String name, String id) onSelected, // callback
  }) {
    final TextEditingController searchController = TextEditingController();
    List<ALL_Name_ID> filteredList = List.from(values);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        filteredList = values
                            .where((item) => item.Name.toLowerCase()
                                .contains(val.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ],
              ),
              content: SizedBox(
                height: 300,
                width: double.maxFinite,
                child: filteredList.isEmpty
                    ? const Center(child: Text("No results found"))
                    : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (ctx, index) {
                          return ListTile(
                            leading: Icon(icon, color: colorPrimary),
                            title: Text(filteredList[index].Name),
                            onTap: () {
                              setState(() {
                                nameController.text = filteredList[index].Name;
                                idController.text =
                                    filteredList[index].pkID?.toString() ?? "";
                                onSelected?.call(filteredList[index].Name,
                                    filteredList[index].pkID?.toString() ?? "");
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "CLOSE",
                    style: TextStyle(color: colorPrimary),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showCustomDialog12({
    BuildContext context,
    String label,
    List<ALL_Name_ID> values,
    TextEditingController nameController,
    TextEditingController idController,
    IconData icon = Icons.person,
    Function(String name, String id) onSelected, // callback
  }) {
    final TextEditingController searchController = TextEditingController();
    List<ALL_Name_ID> filteredList = List.from(values);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        filteredList = values
                            .where((item) => item.Name.toLowerCase()
                                .contains(val.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ],
              ),
              content: SizedBox(
                height: 300,
                width: double.maxFinite,
                child: filteredList.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("No results found"),
                          const SizedBox(height: 15),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text("Use typed text"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimary,
                            ),
                            onPressed: () {
                              String typedText = searchController.text.trim();
                              if (typedText.isNotEmpty) {
                                nameController.text = typedText;
                                idController.clear(); // no id, only name
                                onSelected?.call(typedText, "");
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (ctx, index) {
                          return ListTile(
                            leading: Icon(icon, color: colorPrimary),
                            title: Text(filteredList[index].Name),
                            onTap: () {
                              setState(() {
                                nameController.text = filteredList[index].Name;
                                idController.text =
                                    filteredList[index].pkID?.toString() ?? "";
                                onSelected?.call(filteredList[index].Name,
                                    filteredList[index].pkID?.toString() ?? "");
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "CLOSE",
                    style: TextStyle(color: colorPrimary),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget ClaimDate() {
    return InkWell(
      onTap: () {
        _selectNextFollowupDate(context, edt_expenseDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              "Expense Date *",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            color: colorWhite,
            elevation: 10,
            shadowColor: colorPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_expenseDate.text == null || edt_expenseDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_expenseDate.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_expenseDate.text == null ||
                                  edt_expenseDate.text == ""
                              ? colorGrayDark
                              : colorBlack),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectNextFollowupDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        F_datecontroller.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_ReverseexpenseDate.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }
}
