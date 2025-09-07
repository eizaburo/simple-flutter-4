import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  bool isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            color: Color(0xFFAAAAAA),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text("お問合せフォーム", style: TextStyle(color: Colors.white)),
                Text("お気軽にお問合せ下さい。", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),

          //form
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    //title
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "お問合せタイトル",
                        border: OutlineInputBorder(),
                      ),
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "お問合せタイトルは必須です。";
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),

                    //email
                    SizedBox(height: 30),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Emailは必須です。";
                        }
                        final emailRegExp = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        );
                        if (!emailRegExp.hasMatch(value)) {
                          return "Emailを正しく入力して下さい。";
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),

                    //message
                    SizedBox(height: 30),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "お問合せ内容",
                        border: OutlineInputBorder(),
                      ),
                      minLines: 3,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      controller: _messageController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "お問合せ内容は必須です。";
                        }
                        if (value.length > 10) {
                          return "10文字以下で入力して下さい。";
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),

                    //button
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF333333),
                          foregroundColor: Color(0xFFFFFFFF),
                        ),
                        onPressed: isSubmitting
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  sendFormData(context);
                                }
                              },
                        child: Text("送信"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //データ送信
  void sendFormData(BuildContext context) async {
    // debugPrint('title: \\${_titleController.text}, email: \\${_emailController.text}, message: \\${_messageController.text}',);

    setState(() {
      isSubmitting = true;
    });

    final client = http.Client();
    var url = Uri.parse(
      "https://script.google.com/macros/s/AKfycbyzNZmAv5bxnw-_MF_tZ91q8uxs3AT_Uz0Qomf56EyYyLq9Qr7mFjmLPiZM4HpsWjDv/exec",
    );

    try {
      var response = await http.post(
        url,
        headers: {"Content-type": "application/x-www-form-urlencoded"},
        body: {
          "title": _titleController.text,
          "email": _emailController.text,
          "message": _messageController.text,
        },
      );

      //普通はここで処理
      if (response.statusCode == 200) {
        var text = response.body;
        debugPrint(text);
      }

      //GASのAPIはリダイレクトするので、こっちで処理
      if (response.statusCode == 302) {
        String? location = response.headers['location'];
        if (location != null) {
          var redirectUrl = Uri.parse(location);
          var redirectResponse = await client.get(redirectUrl);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(redirectResponse.body)));
          }
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
        //値のリセット
        _titleController.text = "";
        _emailController.text = "";
        _messageController.text = "";
        //formのリセット（入れ替え）
        _formKey = GlobalKey<FormState>();
      }
    }
  }
}
