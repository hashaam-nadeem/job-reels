import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:jobreels/helper/route_helper.dart';
import '../../data/model/helpers.dart';

class PopupAlert extends StatelessWidget {
  final Function setLoginPopup;
  final PopupObject loginPopup;

  const PopupAlert({
    Key ?key,
    required this.setLoginPopup,
    required this.loginPopup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setLoginPopup(null),
      child: Container(
        constraints: const BoxConstraints.expand(),
        color: const Color(0x88000000),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.only(top: 55, bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 2),
                  blurRadius: 3.84,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/image/logo.png'),
                  radius: 35,
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: () => setLoginPopup(null),
                    child: const Icon(
                      Icons.close,
                      size: 24,
                      color: Color(0xFF444444),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  loginPopup.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Replace with your desired color
                  ),
                ),
                Text(
                  loginPopup.body,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(RouteHelper.getSignInRoute());
                    setLoginPopup(null);
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(horizontal: 25),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 40),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue, // Replace with your desired color
                    ),
                  ),
                  child: Text(
                    loginPopup.buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}