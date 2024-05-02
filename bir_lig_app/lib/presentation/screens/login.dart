import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/presentation/screens/signup.dart';
import 'package:bir_lig_app/provider/userProvider.dart';
import 'package:bir_lig_app/utils/errorHandler.dart';
import 'package:bir_lig_app/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool busy = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckToken();
  }

  void CheckToken() async {
    await Provider.of<UserProvider>(context, listen: false).loadToken();
    if (Provider.of<UserProvider>(context, listen: false).token != null) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(height: 100, child: Image.asset('assets/appstore.png')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Giriş Yap",
                style: _textTheme.headlineLarge,
              ),
              addVerticalSpace(50),
              TextField(
                controller: _emailController,
                decoration:
                    const InputDecoration(hintText: "email", fillColor: INPUT),
                cursorColor: BLACK.withAlpha(100),
                style: TextStyle(color: BLACK.withAlpha(250)),
              ),
              addVerticalSpace(20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "şifre",
                  fillColor: INPUT,
                ),
                cursorColor: BLACK.withAlpha(100),
                style: TextStyle(color: BLACK.withAlpha(250)),
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
                        onPressed: busy
                            ? null
                            : () async {
                                setState(() {
                                  busy = true;
                                });
                                final userProvider = Provider.of<UserProvider>(
                                    context,
                                    listen: false);
                                try {
                                  await userProvider.login(
                                      _emailController.text,
                                      _passwordController.text);
                                  Navigator.of(context)
                                      .pushReplacementNamed('/home');
                                } catch (e) {
                                  if (e is ApiResponse) {
                                    ApiMessanger.show(e, context);
                                  } else {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      ApiMessanger.show(
                                          ApiResponse(
                                              status: "failed",
                                              succes: false,
                                              error: e.toString(),
                                              data: null),
                                          context);
                                    });
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      busy = false;
                                    });
                                  }
                                }
                              },
                        child: busy
                            ? const CircularProgressIndicator(
                                color: WHITE,
                                strokeWidth: 2,
                              )
                            : const Text("Giriş Yap"),
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
