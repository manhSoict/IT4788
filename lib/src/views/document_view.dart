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
  int count = 0;

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
                  '${classId ?? "Class ID"} - ${className ?? "Class Name"}',
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

class DocumentList extends StatefulWidget {
  final Function(String) onTap;

  DocumentList({required this.onTap});

  @override
  _DocumentListState createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  late Future<List<dynamic>> _documentList;

  @override
  void initState() {
    super.initState();
    _documentList = _fetchDocuments();
  }

  // Hàm gọi API và parse JSON
  Future<List<dynamic>> _fetchDocuments() async {
    const String url = 'http://157.66.24.126:8080/it5023e/get_material_list';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? classId = prefs.getString('classId');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "token": token,
          "class_id": classId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        if (responseData['code'] == '1000') {
          return responseData['data'];
        } else {
          throw Exception('Failed to load data: ${responseData['message']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  // Hàm mở dialog hiển thị thông tin tài liệu
  void _showDocumentDetails(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(document['material_name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mô tả: ${document['description']}'),
              SizedBox(height: 8),
              Text('Loại tài liệu: ${document['material_type']}'),
              SizedBox(height: 8),
              InkWell(
                child: Text(
                  'Link tài liệu: ${document['material_link']}',
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () => widget.onTap(document['material_link']),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  // Hàm xử lý menu edit và delete
  void _showEditDeleteMenu(Map<String, dynamic> document) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chọn hành động'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Sửa'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Thực hiện sửa tài liệu ở đây
                  _editDocument(document);
                },
              ),
              ListTile(
                title: Text('Xóa'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Thực hiện xóa tài liệu ở đây
                  _deleteDocument(document['id']);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm thực hiện sửa tài liệu qua API
  Future<void> _editDocument(Map<String, dynamic> document) async {
    final _formKey = GlobalKey<FormState>();
    String materialName = document['material_name'];
    String description = document['description'];
    String materialType = document['material_type'];
    File? selectedFile;

    // Show file picker
    Future<void> _pickFile() async {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false, // Disable multiple file selection
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'ppt',
          'pptx',
          'xls',
          'xlsx'
        ], // Allowed file types
      );

      if (result != null) {
        selectedFile = File(result.files.single.path!);
        setState(() {
          materialType = selectedFile!.path
              .split('.')
              .last; // Set material type based on file extension
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa tài liệu'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: materialName,
                  decoration: InputDecoration(labelText: 'Tên tài liệu'),
                  onChanged: (value) => materialName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên tài liệu';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: description,
                  decoration: InputDecoration(labelText: 'Mô tả'),
                  onChanged: (value) => description = value,
                ),
                TextFormField(
                  initialValue: materialType,
                  decoration: InputDecoration(labelText: 'Loại tài liệu'),
                  onChanged: (value) => materialType = value,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickFile,
                  child: Text('Chọn tệp'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  if (selectedFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Vui lòng chọn tệp để chỉnh sửa tài liệu')),
                    );
                    return;
                  }
                  Navigator.of(context).pop();
                  _submitEdit(materialName, description, materialType,
                      document['id'], selectedFile);
                }
              },
              child: Text('Lưu'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

// Hàm thực hiện gọi API để sửa tài liệu
  Future<void> _submitEdit(String materialName, String description,
      String materialType, String materialId, File? selectedFile) async {
    const String url = 'http://157.66.24.126:8080/it5023e/edit_material';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add the fields (excluding materialLink, now the file is the main data)
      request.fields['materialId'] = materialId;
      request.fields['title'] = materialName;
      request.fields['description'] = description;
      request.fields['materialType'] = materialType;
      request.fields['token'] = token ?? '';

      // Add the file as the main request
      if (selectedFile != null) {
        var file = await http.MultipartFile.fromPath('file', selectedFile.path);
        request.files.add(file);
      }

      // Send the request
      var response = await request.send();

      // Handle response
      if (response.statusCode == 200) {
        print("Material updated successfully.");
        setState(() {
          _documentList = _fetchDocuments();
        });
        // You can show a success message or perform further actions
      } else {
        print("Failed to update material: ${response.statusCode}");
        // Handle failure (e.g., show error message)
      }
    } catch (e) {
      print("Error: $e");
      // Handle errors like network issues or incorrect API endpoint
    }
  }

  // Hàm thực hiện xóa tài liệu qua API
  Future<void> _deleteDocument(String documentId) async {
    const String url = 'http://157.66.24.126:8080/it5023e/delete_material';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(documentId);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "token": token,
          "material_id": int.parse(documentId), // material_id is already an int
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));

        if (responseData['code'] == '1000') {
          // Successfully deleted document
          setState(() {
            _documentList = _fetchDocuments();
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Tài liệu đã được xóa')));
        } else if (responseData['code'] == '1009') {
          // Handle "access denied" error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bạn không có quyền xóa tài liệu')),
          );
        } else {
          // Handle other errors
          throw Exception(
              'Failed to delete document: ${responseData['message']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _documentList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No documents available.'));
        } else {
          final documents = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return ListTile(
                title: Text(document['material_name']),
                onTap: () => _showDocumentDetails(document),
                onLongPress: () =>
                    _showEditDeleteMenu(document), // Thêm long press
              );
            },
          );
        }
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
