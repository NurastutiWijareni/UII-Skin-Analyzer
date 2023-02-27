import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helpers/functions.dart';
import '../../models/analysis_history.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isSignIn = false;
  int jerawatCount = 0;
  bool isUploading = false;
  bool signIn = false;

  void _onPressedSave() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid == false) {
      return;
    }

    try {
      setState(() {
        isUploading = true;
      });

      CollectionReference users = firestore.collection('users');
      String userID = '';

      if (auth.currentUser != null) {
        // await auth.currentUser!.updateEmail(emailController.text);
        // await auth.currentUser!.updatePassword(passwordController.text);

        userID = auth.currentUser!.uid;
      } else {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        userID = userCredential.user!.uid;
      }

      await users.doc(userID).set({
        'name': nameController.text,
        'birthDate': birthDateController.text,
        'jerawatCount': jerawatCount,
      });

      setState(() {
        isUploading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selamat Datang'),
          backgroundColor: Color(0xFF62BBE2),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: const Color(0xFF62BBE2),
          duration: const Duration(seconds: 2),
        ),
      );

      setState(() {
        isUploading = false;
      });
    }
  }

  void _onPressedSignIn() async {
    try {
      setState(() {
        isUploading = true;
      });

      await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      setState(() {
        isUploading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selamat Datang Kembali'),
          backgroundColor: Color(0xFF62BBE2),
          duration: Duration(seconds: 2),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${e.message}'),
          backgroundColor: const Color(0xFF62BBE2),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _changeSignedInState() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  Widget _buildAvatar() {
    return const CircleAvatar(
      backgroundColor: Colors.white,
      radius: 50.0,
      child: CircleAvatar(
        backgroundColor: Color(0xFF62BBE2),
        backgroundImage: AssetImage('assets/images/home_illustrations/jerawat.png'),
        radius: 47.5,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Masukkan email yang benar';
        }
        return null;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      readOnly: (auth.currentUser != null) ? true : false,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan password';
        }
        return null;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        labelText: 'Password',
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: passwordController,
      readOnly: (auth.currentUser != null) ? true : false,
    );
  }

  Widget _buildButton(String buttonText, Icon buttonIcon, VoidCallback onPressed, bool isUploading) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 50,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 1,
            color: Color(0xFF62BBE2),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: const Color(0xFF62BBE2),
          disabledBackgroundColor: const Color(0xFF62BBE2),
          disabledForegroundColor: Colors.white,
        ),
        onPressed: isUploading ? null : onPressed,
        child: isUploading
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Row(
                children: [
                  const SizedBox(width: 10),
                  buttonIcon,
                  const SizedBox(width: 15),
                  Text(buttonText),
                ],
              ),
      ),
    );
  }

  void initData() async {
    CollectionReference users = firestore.collection('users');

    DocumentReference docRef = users.doc(auth.currentUser!.uid);
    DocumentSnapshot<Object?> docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      List<AnalysisHistory> analysisHistory = await fetchAndSetAnalysisHistory();

      setState(() {
        nameController.text = data['name'];
        birthDateController.text = data['birthDate'];
        emailController.text = auth.currentUser!.email!;
        passwordController.text = '12345678';
        jerawatCount = analysisHistory.fold(
            0, (int accumulator, AnalysisHistory myObject) => accumulator + generateJerawats(myObject.jerawatResult!).length);
      });
    }
  }

  @override
  void initState() {
    if (auth.currentUser != null) initData();

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    birthDateController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 14, top: 14, right: 14),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: isSignIn
              ? Column(
                  children: [
                    const SizedBox(height: 90),
                    _buildAvatar(),
                    const SizedBox(height: 30),
                    _buildEmailField(),
                    const SizedBox(height: 30),
                    _buildPasswordField(),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildButton('Registrasi', const Icon(Icons.person_add_alt_1_outlined), _changeSignedInState, false),
                        _buildButton('Masuk', const Icon(Icons.login_outlined), _onPressedSignIn, isUploading)
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildAvatar(),
                    const SizedBox(height: 30),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan nama lengkap';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        labelText: 'Nama Lengkap',
                      ),
                      controller: nameController,
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan tanggal lahir';
                        }
                        if (!RegExp(r'^\d{4}/(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])$').hasMatch(value)) {
                          return 'Masukkan sesuai format: YYYY/MM/DD';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        labelText: 'Tanggal Lahir',
                        hintText: 'YYYY/MM/DD',
                      ),
                      keyboardType: TextInputType.datetime,
                      controller: birthDateController,
                    ),
                    const SizedBox(height: 30),
                    _buildEmailField(),
                    const SizedBox(height: 30),
                    _buildPasswordField(),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        auth.currentUser == null
                            ? _buildButton('Masuk', const Icon(Icons.login_outlined), _changeSignedInState, false)
                            : Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 1,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Jerawat Dideteksi: $jerawatCount',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                        _buildButton('Simpan', const Icon(Icons.save_outlined), _onPressedSave, isUploading),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
