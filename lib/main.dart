import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Validation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Form Validation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _clearFormFields() {
    _formKey.currentState?.fields.forEach((key, field) {
      field.didChange(null);
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
    _clearFormFields();
      print('Form Data: $formData');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Signup Successful.'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Validation Failed.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                _inputField(
                  name: 'email',
                  label: 'Email',
                  icon: Icons.email,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                _inputField(
                  name: 'name',
                  label: 'Name',
                  icon: Icons.person,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(3),
                  ]),
                ),
                _inputField(
                  name: 'phone',
                  label: 'Phone Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.match(RegExp(r'^[0-9]+$')),
                    FormBuilderValidators.minLength(10),
                  ]),
                ),
                _passwordField(
                  name: 'password',
                  label: 'Password',
                  icon: Icons.lock,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(8),
                    FormBuilderValidators.match(
                        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$'),
                        errorText: 'Password must contain letters and numbers'),
                  ]),
                ),
                _passwordField(
                  name: 'confirm_password',
                  label: 'Confirm Password',
                  icon: Icons.lock,
                  validator: (val) {
                    if (val !=
                        _formKey.currentState?.fields['password']?.value) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                FormBuilderDropdown(
                  name: 'gender',
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderCheckboxGroup<String>(
                  name: 'interests',
                  decoration: const InputDecoration(
                    labelText: 'Interests',
                    labelStyle:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                  ),
                  options: const [
                    FormBuilderFieldOption(value: 'Music'),
                    FormBuilderFieldOption(value: 'Travel'),
                    FormBuilderFieldOption(value: 'Photography'),
                    FormBuilderFieldOption(value: 'Sports'),
                  ],
                  validator: FormBuilderValidators.minLength(1,
                      errorText: 'Select at least one interest'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 14)),
                      minimumSize: WidgetStateProperty.all<Size>(
                          Size(MediaQuery.of(context).size.width, 50)),
                      maximumSize: WidgetStateProperty.all<Size>(
                          Size(MediaQuery.of(context).size.width, 50))),
                  onPressed: _submitForm,
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required String name,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FormBuilderTextField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: name,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          iconColor: Colors.indigo,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          errorMaxLines: 2,
        ),
        validator: validator,
      ),
    );
  }
  bool isPasswordVisible = false;
  Widget _passwordField({
    required String name,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FormBuilderTextField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: name,
        obscureText: !isPasswordVisible,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          iconColor: Colors.indigo,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          errorMaxLines: 2,
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          ),
        ),
        validator: validator,
      ),
    );
  }
}
