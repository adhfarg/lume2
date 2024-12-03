import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/health_verification_service.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class HealthCertificationScreen extends StatefulWidget {
  @override
  _HealthCertificationScreenState createState() =>
      _HealthCertificationScreenState();
}

class _HealthCertificationScreenState extends State<HealthCertificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final HealthVerificationService _healthService = HealthVerificationService();

  File? _documentFile;
  DateTime? _lastTestDate;
  Map<String, bool> _stiTests = {
    'HIV': false,
    'Syphilis': false,
    'Gonorrhea': false,
    'Chlamydia': false,
    'Hepatitis': false,
  };
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickDocument() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _documentFile = File(image.path);
          _errorMessage = null;
        });
        print('Document picked: ${image.path}');
      }
    } catch (e) {
      print('Error picking document: $e');
      setState(() {
        _errorMessage = 'Error picking document: $e';
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastTestDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _lastTestDate) {
      setState(() {
        _lastTestDate = picked;
        _errorMessage = null;
      });
      print('Date selected: $picked');
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate() ||
        _documentFile == null ||
        _lastTestDate == null) {
      setState(() {
        _errorMessage =
            'Please fill in all required fields and upload a document';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userId = authService.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      print('Submitting certification for user: $userId');
      final certificationData = {
        'lastTestDate': _lastTestDate!.toIso8601String(),
        'stiTests': _stiTests,
      };

      await _healthService.submitHealthCertification(
        userId,
        certificationData,
        _documentFile!.path,
      );

      print('Certification submitted successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Health certification submitted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error submitting certification: $e');
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Certification'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload Health Documentation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: _pickDocument,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _documentFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_documentFile!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file,
                                size: 50, color: Colors.grey),
                            Text('Tap to upload documentation'),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Last Test Date',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _lastTestDate != null
                            ? '${_lastTestDate!.year}-${_lastTestDate!.month.toString().padLeft(2, '0')}-${_lastTestDate!.day.toString().padLeft(2, '0')}'
                            : 'Select date',
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'STI Tests Completed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ..._stiTests.entries.map((entry) => CheckboxListTile(
                    title: Text(entry.key),
                    value: entry.value,
                    onChanged: (bool? value) {
                      setState(() {
                        _stiTests[entry.key] = value ?? false;
                        _errorMessage = null;
                      });
                    },
                  )),
              SizedBox(height: 24),
              if (_errorMessage != null)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Submit Certification',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
