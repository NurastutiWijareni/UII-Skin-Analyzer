import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import './analysis_result_widget.dart';
import '../utility/camera_screen.dart';
import '../../helpers/db.dart';
import '../../helpers/json.dart';
import '../../models/deteksi_model.dart';

class JerawatAnalysisScreen extends StatefulWidget {
  const JerawatAnalysisScreen({super.key});

  static const routeName = '/jerawat-screen';

  @override
  State<JerawatAnalysisScreen> createState() => _JerawatAnalysisScreenState();
}

class _JerawatAnalysisScreenState extends State<JerawatAnalysisScreen> {
  File? _imageFile;
  List<DeteksiModel> _jerawatData = [];
  int _jerawatCount = 0;
  bool _isServerError = false;
  bool _isUploadingImage = false;

  Future<void> _cachingImage(XFile imageFile) async {
    if (_imageFile != null) {
      await _imageFile!.delete();
      _imageFile = null;
    }

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final finalPath = '${appDir.path}/$fileName';

    File? convertedFile = File(imageFile.path);
    File? savedImage = await convertedFile.copy(finalPath);

    await convertedFile.delete();
    convertedFile = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cachedImage', savedImage.path);

    setState(() {
      _imageFile = savedImage;
      _isServerError = false;
      _isUploadingImage = false;
      _jerawatData = [];
      _jerawatCount = 0;
    });
  }

  Future<void> _fetchCachedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('cachedImage');
    if (imagePath == null) {
      return;
    }

    setState(() {
      _imageFile = File(imagePath);
    });
  }

  Future<void> _saveToDB() async {
    setState(() {
      _isUploadingImage = true;
    });
    final dateNow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2);
    final date = '${DateTime.now().year}${DateTime.now().month}${DateTime.now().day + 2}';

    final dateFormat = DateFormat.yMd().format(dateNow);
    final jsonData = json.encode(_jerawatData);

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final Directory appDocDirFolder = Directory('${appDir.path}/jerawat_history/');
    final Directory appDocDirNewFolder = await appDocDirFolder.create();

    final fileName = path.basename(_imageFile!.path);
    final finalPath = '${appDocDirNewFolder.path}$fileName$date';

    File savedImage = await _imageFile!.copy(finalPath);

    var searchDay = await DBHelper.getSingleData(
      'analysis_results',
      ['id'],
      dateFormat,
    );

    if (searchDay.isNotEmpty) {
      var searchFile = await DBHelper.getSingleData('analysis_results', ['id', 'image_path'], dateFormat);
      var searchedImage = searchFile[0]['image_path'];
      if (searchedImage != savedImage.path && File(searchedImage).existsSync()) {
        File? file = File(searchedImage);
        await file.delete();
        file = null;
      }
    }

    await DBHelper.insert('analysis_results', {
      'id': dateFormat,
      'image_path': savedImage.path,
      'jerawat_result': jsonData,
      'date': dateNow.toString(),
    });

    setState(() {
      _isUploadingImage = false;
    });
  }

  Future<void> _uploadImage() async {
    setState(() {
      _isUploadingImage = true;
    });

    File convertedImage = File(_imageFile!.path);
    var count = 0;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://192.168.126.138:5000/deteksi_jerawat"),
    );
    request.files.add(
      http.MultipartFile(
        'file[]',
        convertedImage.readAsBytes().asStream(),
        convertedImage.lengthSync(),
        filename: convertedImage.path,
      ),
    );

    try {
      var res = await request.send();
      http.Response response = await http.Response.fromStream(res);

      var jsonData = json.decode(response.body);
      JSONResult sample = JSONResult.fromJson(jsonData[0]);

      for (int i = 0; i < sample.deteksiObjek!.jerawat!.length; i++) {
        if (sample.deteksiObjek!.jerawat![i].score! > 0.3) {
          count++;
        }
      }

      setState(() {
        _isUploadingImage = false;
        _isServerError = false;
        _jerawatData = [...(sample.deteksiObjek!.jerawat)!];
        _jerawatCount = count;
      });
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
        _isServerError = true;
        _jerawatData = [];
        _jerawatCount = 0;
      });
    }
  }

  void _pickImage(int index, BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    XFile? imageFile;

    if (index == 0) {
      imageFile = await picker.pickImage(source: ImageSource.gallery);
    } else if (index == 1) {
      imageFile = await Navigator.push<XFile>(context, MaterialPageRoute(builder: (_) => const CameraScreen()));
    }

    if (imageFile == null) {
      return;
    }

    _cachingImage(imageFile);
  }

  Widget _saveImageButton() {
    return _jerawatData.isNotEmpty
        ? Positioned(
            right: 0,
            top: 0,
            child: SizedBox(
              width: 40,
              height: 40,
              child: ElevatedButton(
                onPressed: _isUploadingImage ? null : () => _saveToDB(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E6CDB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  disabledBackgroundColor: const Color(0xFF0E6CDB),
                  disabledForegroundColor: Colors.white,
                ),
                child: const Icon(Icons.save),
              ),
            ),
          )
        : const SizedBox();
  }

  @override
  void initState() {
    super.initState();

    _fetchCachedImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Jerawat',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(
              Icons.help,
              color: Colors.amber,
              size: 36,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFEFF5FF),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: AnalysisResultWidget(
          isServerError: _isServerError,
          imageFile: _imageFile,
          objectData: _jerawatData,
          notificationMessage: 'Terdeteksi $_jerawatCount Jerawat',
          saveResultButton: _saveImageButton(),
          canvasColor: const Color(0xff1572A1),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 24,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: _isUploadingImage
            ? null
            : (value) {
                _pickImage(value, context);
              },
        items: const [
          BottomNavigationBarItem(
            label: 'Galeri',
            icon: ImageIcon(
              AssetImage(
                'assets/images/icons/gallery.png',
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Kamera',
            icon: ImageIcon(
              AssetImage(
                'assets/images/icons/camera.png',
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: _imageFile == null ? Colors.grey : const Color(0xFF0E6CDB),
            onPressed: (_imageFile == null || _isUploadingImage)
                ? null
                : () async {
                    await _uploadImage();
                  },
            child: _isUploadingImage
                ? const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        child: Image.asset(
                          'assets/images/icons/analyze.png',
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      const Text(
                        'Analisis',
                        style: TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
