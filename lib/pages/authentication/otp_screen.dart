import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter_delivery/resources/my_colors.dart';
import 'package:localport_alter_delivery/resources/server_constants.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_authentication_services.dart';
import 'package:localport_alter_delivery/services/auth/code_resend_timer_service.dart';
import 'package:localport_alter_delivery/services/auth/signin_with_phonenumber.dart';
import 'package:localport_alter_delivery/widgets/app_dialogs.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../landing_page.dart';
import 'signup_screen.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  openNextPage() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      openProcessingDialog(context);
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pop(context);

      Provider.of<localportAuthenticationService>(context, listen: false)
          .login(Provider.of<SigninWithPhoneNumber>(context, listen: false)
              .getPhone())
          .then((value) {
        if (value == '') {
          Navigator.pushReplacement(
              context, CupertinoPageRoute(builder: (context) => LandingPage()));
          return;
        }
        if (value == USER_NOT_FOUND || value == 'not delivery partner') {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (context) => SignupScreen(
                      Provider.of<SigninWithPhoneNumber>(context, listen: false)
                          .getPhone())));
          return;
        }
        if (value == 'CT3001' || value == 'CT3002') {
          showVeriFailMessage("Please try again after sometime");
        }
      });
    } catch (err) {
      showVeriFailMessage("Please try again after sometime");
    }
  }

  showVeriFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  initTimer() {
    Provider.of<CodeResendTimerService>(context, listen: false).initTime();
  }

  @override
  void initState() {
    super.initState();

    initTimer();
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Otp",
                  style: GoogleFonts.padauk(
                      color: Colors.black,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PinCodeTextField(
                    controller: _otpController,
                    length: 6,
                    pinTheme: PinTheme(
                        activeColor: MyColors.colorDark,
                        inactiveColor: Colors.black,
                        selectedColor: MyColors.colorDark,
                        borderWidth: 1,
                        borderRadius: BorderRadius.circular(6),
                        shape: PinCodeFieldShape.box),
                    appContext: context,
                    onChanged: (String value) {
                      //verify Otp
                    },
                  ),
                ),
                Consumer<CodeResendTimerService>(
                    builder: (context, snapshot, child) {
                  return SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () {
                        if (snapshot.getTime() <= 0) {
                          openProcessingDialog(context);
                          Provider.of<SigninWithPhoneNumber>(context,
                                  listen: false)
                              .phoneSignin(Provider.of<SigninWithPhoneNumber>(
                                      context,
                                      listen: false)
                                  .getPhone());
                          initTimer();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        snapshot.getTime() > 0
                            ? "Resend OTP in ${snapshot.getTime()} sec(s)"
                            : "Resend OTP",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.roboto(
                            color: snapshot.getTime() > 0
                                ? Colors.grey
                                : MyColors.color1,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              snapshot.getTime() > 0
                                  ? const BoxShadow()
                                  : BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(1, 1))
                            ]),
                      ),
                    ),
                  );
                }),
                Consumer<SigninWithPhoneNumber>(
                    builder: (context, snapshot, child) {
                  if (snapshot.isVerificationComplete()) {
                    openNextPage();
                  }

                  if (snapshot.isVerificationFailed()) {
                    showVeriFailMessage(snapshot.getVerificationFailMessage());
                  }
                  return GestureDetector(
                    onTap: () {
                      if (_otpController.text != null ||
                          _otpController.text != "") {
                        snapshot.verifyCode(_otpController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Enter otp ")));
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
                          "Verify",
                          style: GoogleFonts.padauk(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
