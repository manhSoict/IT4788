import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../ui/components/header2.dart';

class DocumentTabScreen extends StatefulWidget {
  const DocumentTabScreen({
    Key? key,
  }) : super(key: key);
  @override
  _DocumentTabScreenState createState() => _DocumentTabScreenState();
}

class _DocumentTabScreenState extends State<DocumentTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? role;
  String? name;
  String? studentId;
  String? startTime;
  String? endTime;
  String? classId;
  String? className;
  String? location;
  String? scheduleDetail;
  String? week;
  String? classType;
  String? attachedCode;
  String? lecturerName;
  String? studentCount;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role'); // Ví dụ: Sinh viên/Giảng viên
      name = prefs.getString('name');
      studentId = prefs.getString('studentId');
      classId = prefs.getString('classId');
      className = prefs.getString('className');
      startTime = prefs.getString('startTime');
      endTime = prefs.getString('endTime');
      location = prefs.getString('location');
      scheduleDetail = prefs.getString('scheduleDetail');
      week = prefs.getString('week');
      attachedCode = prefs.getString('attachedCode');
      lecturerName = prefs.getString('lecturerName');
      classType = prefs.getString('classType');
      studentCount = prefs.getString('studentCount');
    });
  }

  void _onDocumentTap(String title) {
    print('Opened document: $title');
    // Add logic here to handle document opening, e.g., navigation or file viewing.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: const Header2(title: 'Tài liệu'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IT4788 - Phát triển ứng dụng da nền tảng',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.red,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.red,
                  tabs: [
                    Tab(text: 'Danh sách tài liệu'),
                    Tab(text: 'Thêm tài liệu'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                DocumentList(onTap: _onDocumentTap),
                AddDocumentForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentList extends StatelessWidget {
  final Function(String) onTap;

  DocumentList({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text('Tài liệu về con lắc đơn'),
          children: [
            ListTile(
              title: Text('Tài liệu 1'),
              onTap: () => onTap('Tài liệu 1'),
            ),
            ListTile(
              title: Text('Tài liệu 2'),
              onTap: () => onTap('Tài liệu 2'),
            ),
            ListTile(
              title: Text('Tài liệu 3'),
              onTap: () => onTap('Tài liệu 3'),
            ),
          ],
        );
      },
    );
  }
}

class AddDocumentForm extends StatefulWidget {
  @override
  _AddDocumentFormState createState() => _AddDocumentFormState();
}

class _AddDocumentFormState extends State<AddDocumentForm> {
  String? token;
  String? classId;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _selectedFile;
  String _uploadMessage = '';
  String? _fileType;

  // Hàm chọn file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileType =
            path.extension(_selectedFile!.path).substring(1).toUpperCase();
      });
    }
  }

  // Hàm upload tài liệu
  Future<void> _uploadDocument() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    classId = prefs.getString('classId');

    if (_selectedFile == null) {
      _showMessage('Vui lòng chọn một tệp!', Colors.red);
      return;
    }

    const String url = 'http://157.66.24.126:8080/it5023e/upload_material';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Thêm các trường thông tin
      request.fields['token'] = token ?? '';
      request.fields['classId'] = classId ?? "";
      request.fields['title'] = _titleController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['materialType'] = _fileType ?? 'UNKNOWN';

      // Thêm file vào request
      request.files
          .add(await http.MultipartFile.fromPath('file', _selectedFile!.path));

      // Gửi request và lấy phản hồi
      var response = await request.send();

      // Đọc phản hồi từ server
      var responseBody = await response.stream.bytesToString();
      var responseData = jsonDecode(responseBody);

      if (response.statusCode == 200 && responseData['code'] == '1000') {
        // Thành công
        _showMessage(responseData['message'], Colors.green);
      } else {
        // Thất bại
        _showMessage(responseData['message'] ?? 'Upload thất bại!', Colors.red);
      }
    } catch (e) {
      _showMessage('Đã xảy ra lỗi: $e', Colors.red);
    }
  }

  // Hiển thị thông báo
  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tiêu đề:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nhập tiêu đề',
            ),
          ),
          SizedBox(height: 16),
          Text('Mô tả:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nhập thông tin mô tả tài liệu',
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _pickFile,
            icon: Icon(Icons.attach_file),
            label: Text('Chọn tệp'),
          ),
          if (_selectedFile != null) ...[
            SizedBox(height: 8),
            Text('Tệp đã chọn: ${_selectedFile!.path.split('/').last}'),
          ],
          Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _uploadDocument,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Đăng',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
