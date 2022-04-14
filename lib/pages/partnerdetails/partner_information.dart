import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localport_alter_delivery/SharedPreferences/sharedpreferences_class.dart';
import 'package:localport_alter_delivery/resources/my_colors.dart';
import 'package:localport_alter_delivery/resources/server_constants.dart';
import 'package:localport_alter_delivery/resources/strings.dart';
import 'package:localport_alter_delivery/widgets/app_dialogs.dart';
import 'package:provider/provider.dart';
import '../landing_page.dart';

class PartnerInformation extends StatefulWidget {
  @override
  PartnerInformationState createState() => PartnerInformationState();
}

class PartnerInformationState extends State<PartnerInformation> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _businessName = TextEditingController();
  final TextEditingController _businessDescription = TextEditingController();

  savePartnerDetails() async {
    // try {
    //   openProcessingDialog(context);
    //   File image = Provider.of<PartnerInformationService>(context, listen: false)
    //       .getImage();
    //   List<int> _byteCode;
    //   String base64Image;
    //   if (image != null) {
    //     _byteCode = image.readAsBytesSync();
    //     base64Image = base64Encode(_byteCode);
    //   }
    //   String uid = await SharedPreferencesClass().getUid();
    //   Provider.of<PartnerRegistrationService>(context, listen: false)
    //       .savePartner(
    //           uid, _businessName.text, _businessDescription.text, base64Image)
    //       .then((value) {
    //         Navigator.pop(context);
    //     if (value == "") {
    //       Navigator.pushReplacement(context,
    //           CupertinoPageRoute(builder: (context) => const LandingPage()));
    //     }
    //     if (value == 500 || value == SOMETHING_WENT_WRONG || value == INVALID_REQUEST) {
    //       showFailMessage("Please try again after sometime");
    //     }
    //   });
    // } catch (err) {
    //   print(err);
    //   showFailMessage("Please try again after sometime");
    // }
  }

  showFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.color1,
      body: SafeArea(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children: [
                    Text(
                      "Partner Information",
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              ImagePicker()
                                  .pickImage(source: ImageSource.gallery)
                                  .then((value) {
                                // snapshot.setImage(File(value.path));
                              });
                            },
                            child: Stack(
                              children: [
                                // CircleAvatar(
                                //   radius:
                                //   MediaQuery
                                //       .of(context)
                                //       .size
                                //       .width / 8,
                                //   foregroundImage: snapshot.getImage() == null
                                //       ? Image
                                //       .asset(appIcon)
                                //       .image
                                //       : Image
                                //       .file(snapshot.getImage())
                                //       .image,
                                // ),
                                CircleAvatar(
                                  backgroundColor:
                                  Colors.grey.withOpacity(0.6),
                                  child: const Icon(Icons.image),
                                )
                              ],
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
                                  controller: _businessName,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Enter your business name";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      hintText: 'Business Name',
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
                                  controller: _businessDescription,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Describe your business";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      hintText: 'About your business',
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
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          savePartnerDetails();
                        }
                      },
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
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
                )
            ),
          )),
    );
  }
}
