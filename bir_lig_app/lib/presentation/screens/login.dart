import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/presentation/screens/signup.dart';
import 'package:bir_lig_app/provider/userProvider.dart';
import 'package:bir_lig_app/utils/errorHandler.dart';
import 'package:bir_lig_app/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "birLig",
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Giriş Yap",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              addVerticalSpace(50),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: "email",
                      fillColor: INPUT,
                      hintStyle: TextStyle(color: BLACK.withAlpha(150))),
                  cursorColor: BLACK.withAlpha(100),
                  style: TextStyle(color: BLACK.withAlpha(250)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      hintText: "şifre",
                      fillColor: INPUT,
                      hintStyle: TextStyle(color: BLACK.withAlpha(150))),
                  cursorColor: BLACK.withAlpha(100),
                  style: TextStyle(color: BLACK.withAlpha(250)),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 35, horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupPage()));
                            },
                            child: const Text(
                              "Kayıt ol",
                              style: TextStyle(
                                  color: COLOR_SECONDARY,
                                  fontWeight: FontWeight.bold),
                            ))),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          try {
                            await userProvider.login(_emailController.text,
                                _passwordController.text);
                            Navigator.of(context).pushReplacementNamed('/home');
                          } catch (e) {
                            if(e is ApiResponse)
                              ApiMessanger.show(e as ApiResponse, context);
                            else
                              ApiMessanger.show(ApiResponse(status: "failed",succes: false, error: "Beklenmedik bir hata oluştu", data: null), context);
                          }
                        },
                        child: Text('Giriş Yap'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
