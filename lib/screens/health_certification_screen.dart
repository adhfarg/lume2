import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/auth_service.dart';
import '../services/health_verification_service.dart';

class HealthCertificationScreen extends StatefulWidget {
  @override
  _HealthCertificationScreenState createState() =>
      _HealthCertificationScreenState();
}

class _HealthCertificationScreenState extends State<HealthCertificationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _stdTest = '';
  String _hivTest = '';
  String _covidVaccination = '';
  XFile? _testResultFile;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    try {
      final status = await Permission.photos.request();
      if (status.isGranted) {
        final ImagePicker picker = ImagePicker();
        final XFile? file = await picker.pickImage(source: ImageSource.gallery);
        if (file != null) {
          setState(() {
            _testResultFile = file;
          });
        }
      } else if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Permission to access photos was denied. Please enable it in settings.')),
        );
      } else if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final healthVerificationService =
        Provider.of<HealthVerificationService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Health Certification')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'STD Test Result'),
              validator: (value) =>
                  value!.isEmpty ? 'This field is required' : null,
              onSaved: (value) => _stdTest = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'HIV Test Result'),
              validator: (value) =>
                  value!.isEmpty ? 'This field is required' : null,
              onSaved: (value) => _hivTest = value!,
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'COVID-19 Vaccination Status'),
              validator: (value) =>
                  value!.isEmpty ? 'This field is required' : null,
              onSaved: (value) => _covidVaccination = value!,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text(_testResultFile == null
                  ? 'Upload Test Result'
                  : 'Change Test Result'),
            ),
            if (_testResultFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('File selected: ${_testResultFile!.name}'),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Submit Health Certification'),
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate() &&
                          _testResultFile != null) {
                        _formKey.currentState!.save();
                        setState(() => _isLoading = true);
                        try {
                          final certificationId =
                              await healthVerificationService
                                  .submitHealthCertification(
                            authService.currentUserId!,
                            {
                              'stdTest': _stdTest,
                              'hivTest': _hivTest,
                              'covidVaccination': _covidVaccination,
                            },
                            _testResultFile!.path,
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
                                content: Text(
                                    'Error submitting health certification: ${e.toString()}')),
                          );
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Please complete all fields and upload a test result')),
                        );
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
