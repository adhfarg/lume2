import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final healthVerificationService =
        Provider.of<HealthVerificationService>(context);

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
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Submit Health Certification'),
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() => _isLoading = true);
                        try {
                          final certificationId =
                              await healthVerificationService
                                  .submitHealthCertification(
                            authService.currentUser!.uid,
                            {
                              'stdTest': _stdTest,
                              'hivTest': _hivTest,
                              'covidVaccination': _covidVaccination,
                            },
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
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
