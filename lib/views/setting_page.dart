import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medixpos/models/settings.dart';
import 'package:medixpos/providers/settings_provider.dart';
import 'package:provider/provider.dart';

import 'dart:io'; // Import for File

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late CompanySettings _currentSetting;
  File? _logoImage; // Variable to hold the logo image file
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

  @override
  void initState() {
    super.initState();
    // Get current settings from provider
    final provider = Provider.of<CompanySettingProvider>(context, listen: false);
    _currentSetting = provider.companySettings.isNotEmpty ? provider.companySettings[0] : CompanySettings(
      companyName: '',
      businessType: '',
      ownerName: '',
      address: '',
      phoneNumber: '',
      logoPath: '',
      gstNumber: '',
      registrationNumber: '',
      bankAccountNumber: '',
      ifscCode: '',
      accountName: '',
      upiAddress: '',
    );
  }

  Future<void> _pickLogoImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _logoImage = File(pickedFile.path);
          _currentSetting.logoPath = pickedFile.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }


  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save the updated settings
      final provider = Provider.of<CompanySettingProvider>(context, listen: false);
      provider.saveCompanySetting(_currentSetting);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _currentSetting.companyName,
                  decoration: InputDecoration(labelText: 'Company Name'),
                  onSaved: (value) => _currentSetting.companyName = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter company name' : null,
                ),
                TextFormField(
                  initialValue: _currentSetting.businessType,
                  decoration: InputDecoration(labelText: 'Business Type'),
                  onSaved: (value) => _currentSetting.businessType = value!,
                ),
                TextFormField(
                  initialValue: _currentSetting.ownerName,
                  decoration: InputDecoration(labelText: 'Owner Name'),
                  onSaved: (value) => _currentSetting.ownerName = value!,
                ),
                TextFormField(
                  initialValue: _currentSetting.address,
                  decoration: InputDecoration(labelText: 'Address'),
                  onSaved: (value) => _currentSetting.address = value!,
                ),
                TextFormField(
                  initialValue: _currentSetting.phoneNumber,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  onSaved: (value) => _currentSetting.phoneNumber = value!,
                ),
                // Logo selection
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickLogoImage,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(8),
                      image: _logoImage != null
                          ? DecorationImage(
                        image: FileImage(_logoImage!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _logoImage == null
                        ? Center(child: Text('Tap to select logo'))
                        : null,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _currentSetting.gstNumber,
                  decoration: InputDecoration(labelText: 'GST Number'),
                  onSaved: (value) => _currentSetting.gstNumber = value!,
                ),
                TextFormField(
                  initialValue: _currentSetting.registrationNumber,
                  decoration: InputDecoration(labelText: 'Registration Number'),
                  onSaved: (value) => _currentSetting.registrationNumber = value!,
                ),
                TextFormField(
                  initialValue: _currentSetting.bankAccountNumber,
                  decoration: InputDecoration(labelText: 'Bank Account Number'),
                  onSaved: (value) => _currentSetting.bankAccountNumber = value!,
                ),
                TextFormField(
                  initialValue: _currentSetting.ifscCode,
                  decoration: InputDecoration(labelText: 'IFSC Code'),
                  onSaved: (value) => _currentSetting.ifscCode = value!,
                ),
                TextFormField(
                  initialValue: _currentSetting.accountName,
                  decoration: InputDecoration(labelText: 'Account Name'),
                  onSaved: (value) => _currentSetting.accountName = value!,
                ),
                TextFormField(
                  initialValue: _currentSetting.upiAddress,
                  decoration: InputDecoration(labelText: 'UPI Address'),
                  onSaved: (value) => _currentSetting.upiAddress = value!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveSettings,
                  child: Text('Save Settings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
