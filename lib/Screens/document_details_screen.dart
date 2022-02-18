import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:project/Controllers/firebase_controller.dart';

class DocumentDetailsScreen extends StatefulWidget {
  const DocumentDetailsScreen({Key? key}) : super(key: key);

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  File? image;
  File? pickedPDF;
  String? pathOfCreatedPDF;
  final pdf = pw.Document();
  final _formKey = GlobalKey<FormState>();

  FirebaseService _firebaseService = FirebaseService();

  //Textfield Controllers
  final _descController = TextEditingController();
  final _filenameController = TextEditingController();

  //date and time
  DateTime selectedDate = DateTime.now();

  //location lat and long
  String _locationLat = "0";
  String _locationLong = "0";

  // To scan document from camera
  Future scanDocumentFromCamera(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      final tempImage = File(image.path);
      //uploadImagetFirebase(tempImage.path);

      setState(() {
        this.image = tempImage;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image $e');
    }
  }

  // To upload document from storage
  Future uploadDocumentFromStorage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      setState(() {
        pickedPDF = File(result.files.single.path!);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _getCurrentLocation() async {
    await Geolocator.requestPermission();
    Position postion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _locationLat = '${postion.latitude}';
      _locationLong = '${postion.longitude}';
    });
  }

  createPDF() async {
    final pdfimage = pw.MemoryImage(
      File(image!.path).readAsBytesSync(),
    );

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pdfimage),
          );
        }));
  }

  savePDF(String filename) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename.pdf');
      await file.writeAsBytes(await pdf.save());
      print('pdf path: ${file.path}');
      setState(() {
        pathOfCreatedPDF = file.path.toString();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Enter Document Details",
                style: TextStyle(fontSize: 20),
              ),
              Divider(),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image != null
                      ? Image.file(
                          image!,
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        )
                      : Placeholder(
                          fallbackHeight: 75,
                          fallbackWidth: 75,
                        ),
                  SizedBox(width: 15),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return document_picker_options();
                          });
                    },
                    child: Icon(Icons.file_upload_outlined),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "File Name",
                            border: OutlineInputBorder(),
                            hintText: "Enter document Description"),
                        controller: _filenameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the document description";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Description",
                            border: OutlineInputBorder(),
                            hintText: "Enter document Description"),
                        controller: _descController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the document description";
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ListTile(
                          tileColor: Colors.white12,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          title:
                              Text("${selectedDate.toLocal()}".split(' ')[0]),
                          trailing: Icon(Icons.calendar_today),
                          onTap: () => _selectDate(context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          contentPadding: EdgeInsets.all(15.0),
                          tileColor: Colors.white12,
                          title: Text(
                              'Latitude: $_locationLat  \n\nLongtitue: $_locationLong'),
                          trailing: Icon(Icons.gps_fixed),
                          onTap: () => _getCurrentLocation(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          createPDF();
                          await savePDF(_filenameController.text);

                          String imgurl =
                              await _firebaseService.uploadImagetFirebase(
                                  pathOfCreatedPDF!, _filenameController.text);
                          await _firebaseService
                              .uploadDocumentDetailsToFirebase({
                            'desc': _descController.text,
                            'filename': _filenameController.text,
                            'date': selectedDate,
                            'lat': _locationLat,
                            'long': _locationLong,
                            'imgurl': imgurl.toString()
                          });

                          _ShowUploadCompleteMessage(
                              context, 'Document uploaded Successfully!');
                        },
                        child: Text('Upload Document'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _ShowUploadCompleteMessage(
      BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            message,
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 60,
            child: Center(
              child: Icon(
                Icons.check,
                size: 100,
                color: Colors.green,
              ),
            ),
          ),
          alignment: Alignment.center,
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.popAndPushNamed(context, '/folder'),
                child: Text('Ok'),
                style: ElevatedButton.styleFrom(primary: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget document_picker_options() {
    return SafeArea(
      child: Container(
        height: 120,
        child: Column(
          children: [
            TextButton(
              onPressed: () => uploadDocumentFromStorage(),
              child: Text('Add Document from Storage'),
            ),
            TextButton(
              onPressed: () => scanDocumentFromCamera(ImageSource.camera),
              child: Text('Scan Document from Camera'),
            )
          ],
        ),
      ),
    );
  }
}
