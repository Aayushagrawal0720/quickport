import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter_delivery/resources/my_colors.dart';
import 'package:localport_alter_delivery/services/location_locality_service.dart';
import 'package:provider/provider.dart';

PermissionDialogue(BuildContext context) async {
  await Future.delayed(Duration(milliseconds: 200));
  Dialog dialog = Dialog(
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Permission Denied",
            style: GoogleFonts.roboto(
                color: Colors.black, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            "Please enable location for application in device setting.",
            style: GoogleFonts.roboto(
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.color1,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                child: Text(
                  "Ok",
                  style: GoogleFonts.roboto(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );

  showDialog(context: context, builder: (context) => dialog);
}

openProcessingDialog(BuildContext context) {
  var dialog = Dialog(
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 8,
                offset: Offset(0, 0))
          ],
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: const SpinKitSquareCircle(
        color: MyColors.color1,
        size: 28,
      ),
    ),
  );
  showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return dialog;
      });
}

enableLocationServiceDialog(BuildContext context) {
  var dialog = Dialog(
      elevation: 3,
      child: WillPopScope(
        onWillPop: () {
          return;
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 0))
              ],
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Enable location service use this application",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: MyColors.greyWhite,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                                color: MyColors.greyWhite,
                                offset: Offset(0, 0),
                                blurRadius: 6)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: GestureDetector(
                          onTap: () async {
                            if (await Geolocator.isLocationServiceEnabled()) {
                              Provider.of<LocationLocalityService>(context,
                                      listen: false)
                                  .fetchLocality(context);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Try again",
                            style: GoogleFonts.roboto(color: MyColors.color3),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: MyColors.color3,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                                color: MyColors.greyWhite,
                                offset: Offset(0, 0),
                                blurRadius: 6)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: GestureDetector(
                          onTap: () async {
                            Geolocator.openLocationSettings();
                          },
                          child: Text(
                            "Ok",
                            style: GoogleFonts.roboto(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ));

  showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return dialog;
      });
}
