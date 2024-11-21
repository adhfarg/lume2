import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/health_verification_service.dart';

class HealthCertificationScreen extends StatefulWidget {
  @override
  _HealthCertificationScreenState createState() =>
      _HealthCertificationScreenState();
}

class _HealthCertificationScreenState extends State<HealthCertificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _documentImage;
  DateTime? _lastTestDate;
  Map<String, bool> _stiTests = {
    'HIV': false,
    'Syphilis': false,
    'Gonorrhea': false,
    'Chlamydia': false,
    'Hepatitis': false,
  };

  Future<void> _pickDocument() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _documentImage = File(image.path);
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
                  child: _documentImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _documentImage!,
                            fit: BoxFit.cover,
                          ),
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              ..._stiTests.entries.map((entry) => CheckboxListTile(
                    title: Text(entry.key),
                    value: entry.value,
                    onChanged: (bool? value) {
                      setState(() {
                        _stiTests[entry.key] = value ?? false;
                      });
                    },
                  )),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      _documentImage != null &&
                      _lastTestDate != null) {
                    try {
                      final healthService = HealthVerificationService();
                      final certificationData = {
                        'lastTestDate': _lastTestDate!.toIso8601String(),
                        'stiTests': _stiTests,
                      };

                      await healthService.submitHealthCertification(
                        'current_user_id', // Replace with actual user ID
                        certificationData,
                        _documentImage!.path,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Health certification submitted successfully')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Error submitting certification: $e')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Please fill in all required fields')),
                    );
                  }
                },
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
                  child: Text(
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
