import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import '../../../controller/auth_controller.dart';

class AdminCustomDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AdminCustomDrawer();
  }
}

class _AdminCustomDrawer extends State<AdminCustomDrawer> {
  var width, height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Container(
      width: width * .6,
      height: height,
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(width * .03),
      child: Column(
        children: [
          SizedBox(
            height: height * .04,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width * .2,
                height: height * .08,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("assets/image/logo.png"))),
              )
            ],
          ),
          SizedBox(
            height: height * .02,
          ),
          ListTile(
            splashColor: Colors.white,
            tileColor: Colors.white,
            hoverColor: Colors.white,
            selectedTileColor: Colors.white,
            trailing: Icon(
              Icons.logout,
              color: Colors.white,
              size: height * .03,
            ),
            title: Text(
              "Logout",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Get.find<AuthController>().logout();
            },
          ),
        ],
      ),
    );
  }
}
