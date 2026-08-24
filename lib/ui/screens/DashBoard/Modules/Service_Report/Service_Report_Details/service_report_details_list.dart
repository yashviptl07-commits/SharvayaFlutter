import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/workNotes_model.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class ServiceReportWorkNotesScreenArgument {
  final String ServiceNo;
  ServiceReportWorkNotesScreenArgument(this.ServiceNo);
}

class ServiceReportWorkNotesScreen extends BaseStatefulWidget {
  static const routeName = '/ServiceReportWorkNotesScreen';
  final ServiceReportWorkNotesScreenArgument arguments;
  ServiceReportWorkNotesScreen(this.arguments);

  @override
  _ServiceReportWorkNotesScreenState createState() =>
      _ServiceReportWorkNotesScreenState();
}

class _ServiceReportWorkNotesScreenState
    extends BaseState<ServiceReportWorkNotesScreen>
    with BasicScreen, WidgetsBindingObserver {
  final List<WorkNotesTable> _notesList = [];
  final TextEditingController _srNoController = TextEditingController();
  final TextEditingController _workNotesController = TextEditingController();

  int _editingNoteId;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  String LoginUserID;
  String CompanyID;
  MainBloc _mainBloc;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId.toString();
    _mainBloc = MainBloc(baseBloc);
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    final notes = await OfflineDbHelper.getInstance().getWorkNotes();
    setState(() {
      _notesList.clear();
      _notesList.addAll(notes);
      _isLoading = false;
    });
  }

  Future<void> _saveNote() async {
    if (_srNoController.text.isEmpty || _workNotesController.text.isEmpty)
      return;

    // Close keyboard
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    final note = WorkNotesTable(
      '',
      _srNoController.text,
      widget.arguments.ServiceNo,
      _workNotesController.text,
      LoginUserID,
      CompanyID,
      id: _editingNoteId,
    );

    final isUpdate = _editingNoteId != null;

    if (isUpdate) {
      await OfflineDbHelper.getInstance().updateWorkNotes(note);
    } else {
      await OfflineDbHelper.getInstance().insertWorkNotes(note);
    }

    // Clear form fields
    _srNoController.clear();
    _workNotesController.clear();
    _editingNoteId = null;

    // Reload list
    await _loadNotes();

    setState(() => _isLoading = false);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            isUpdate ? 'Note updated successfully' : 'Note added successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _deleteNote(int id) async {
    setState(() => _isLoading = true);
    await OfflineDbHelper.getInstance().deleteWorkNotes(id);
    _loadNotes();
  }

  void _startEditNote(WorkNotesTable note) {
    setState(() {
      _srNoController.text = note.SrNo;
      _workNotesController.text = note.WorkNotes;
      _editingNoteId = note.id;
    });
  }

  Widget _buildWorkNotesSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add / Update Work Note",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorPrimary)),
                  SizedBox(height: 10),
                  TextField(
                    controller: _srNoController,
                    decoration: InputDecoration(
                      labelText: 'Sr No',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _workNotesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Work Notes',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _saveNote,
                      child: Text(
                        _editingNoteId != null ? 'Update Note' : 'Add Note',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text("Work Notes List",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorPrimary)),
          SizedBox(height: 10),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _notesList.isEmpty
                    ? Center(child: Text("No work notes found"))
                    : Card(
                        elevation: 10,
                        shadowColor: colorPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListView.separated(
                          padding: EdgeInsets.all(8),
                          itemCount: _notesList.length,
                          separatorBuilder: (_, __) => Divider(),
                          itemBuilder: (context, index) {
                            final note = _notesList[index];
                            return Card(
                              elevation: 10,
                              shadowColor: colorPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                tileColor: Colors.grey[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                title: Text("Sr No: ${note.SrNo}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(note.WorkNotes),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _startEditNote(note),
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteNote(note.id),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _mainBloc..add(MaterialInwardDetailsListEvent()),
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (context, state) => buildBody(context),
        buildWhen: (_, __) => false,
        listener: (_, __) {},
        listenWhen: (_, __) => false,
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        title: Text("Service Report Work Notes"),
      ),
      body: _buildWorkNotesSection(),
    );
  }
}
