import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter_delivery/pages/landing_page.dart';
import 'package:localport_alter_delivery/pages/partnerdetails/partner_information.dart';
import 'package:localport_alter_delivery/resources/auth_page_designs_resource.dart';
import 'package:localport_alter_delivery/resources/my_colors.dart';
import 'package:localport_alter_delivery/resources/server_constants.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_authentication_services.dart';
import 'package:localport_alter_delivery/services/auth/signin_with_phonenumber.dart';
import 'package:localport_alter_delivery/widgets/app_dialogs.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  String phoneNumber;

  SignupScreen(this.phoneNumber);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignupScreen> {
  User _user;

  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final GlobalKey<FormState> _nameForm = GlobalKey();

  signupAndNext() {
    Provider.of<localportAuthenticationService>(context, listen: false)
        .signup(_user.uid, _firstname.text, _lastname.text, widget.phoneNumber)
        .then((value) async {
      if (value == "") {
        Navigator.pop(context);
        await Future.delayed(const Duration(milliseconds: 200));
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => const LandingPage()));
      }
      if (value == SOMETHING_WENT_WRONG || value == INVALID_REQUEST) {
        showVeriFailMessage("Please try again after sometime");
      }
    });
  }

  showVeriFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _user =
        Provider.of<SigninWithPhoneNumber>(context, listen: false).getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.white),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: ClipPath(
                clipper: CurveClipper(),
                child: Container(
                  color: MyColors.color1,
                  height: MediaQuery.of(context).size.height / 3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Please enter your name first",
                          style: GoogleFonts.padauk(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _nameForm,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                controller: _firstname,
                                autofocus: true,
                                keyboardType: TextInputType.name,
                                enableSuggestions: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter your first name';
                                  }

                                  return null;
                                },
                                decoration: const InputDecoration(
                                    hintText: 'First Name',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    fillColor: MyColors.color3,
                                    border: InputBorder.none),
                                cursorColor: Colors.black,
                                textAlign: TextAlign.left,
                                style: const TextStyle(color: Colors.black)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                controller: _lastname,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter your last name';
                                  }

                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                enableSuggestions: true,
                                decoration: const InputDecoration(
                                    hintText: 'Last Name',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    fillColor: MyColors.color3,
                                    border: InputBorder.none),
                                cursorColor: Colors.black,
                                textAlign: TextAlign.left,
                                style: const TextStyle(color: Colors.black)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_nameForm.currentState.validate()) {
                              openProcessingDialog(context);
                              signupAndNext();
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: MyColors.colorDark,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black38,
                                      offset: Offset(0, 0),
                                      blurRadius: 6),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              child: Text(
                                "Proceed",
                                style: GoogleFonts.padauk(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      )),
    );
  }
}
