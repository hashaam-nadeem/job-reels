import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:workerapp/utils/app_images.dart';
import 'package:workerapp/utils/color_constants.dart';
import 'package:workerapp/utils/styles.dart';
import 'package:workerapp/view/base/custom_app_bar.dart';
import 'package:workerapp/view/screens/profile/widgets/home_widget.dart';
import 'package:workerapp/view/screens/profile/widgets/profile_widget.dart';
import 'package:workerapp/view/screens/shift/widgets/profile_widget_portion.dart';
import '../../../controller/auth_controller.dart';
import '../../../utils/app_strings.dart';
import 'widgets/documnet_widget.dart';
import 'widgets/shifts_widget.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key,}) : super(key: key);

  @override
  MyAccountScreenState createState() => MyAccountScreenState();
}

class MyAccountScreenState extends State<MyAccountScreen> {

  int currentTabIndex = 0;

  List<Widget>tabBarWidgetList = <Widget>[
    const HomeWidget(),
    const ProfileWidget(),
    const DocumentWidget(),
    const ShiftsWidget(),
  ];

@override
void initState() {
  Get.find<AuthController>().fetchProfile();
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackGroundColor,
      appBar: CustomAppBar(
        title: AppString.staffProfile,
        leading: IconButton(
          onPressed: (){

          },
          iconSize: 20,
          icon: const Icon(Icons.menu,color: Colors.white,),
        ),
        trailing: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.logout,color: Colors.white,),
          ),
        ],
      ),
      body: SafeArea(
          child: Container(
            width:context.width,
            height: context.height,
            color: AppColor.scaffoldBackGroundColor,
            child: Column(
              children: [
                ProfileWidgetPortion(isMyProfile: true,currentIndex: currentTabIndex,),
                NeumorphicToggle(
                  style: const NeumorphicToggleStyle(
                    depth: 200,
                    backgroundColor: Colors.white,
                  ),
                  selectedIndex: currentTabIndex,
                    onChanged: (value){
                      currentTabIndex = value;
                      setState((){});
                    },
                  height: 50,
                    children: [
                     ToggleElement(
                       background: menuWidgetButton(text: 'Home',image: Images.home,isSelected: currentTabIndex==0),
                       foreground: menuWidgetButton(text: 'Home',image: Images.home,isSelected: currentTabIndex==0),
                     ),
                      ToggleElement(
                        background: menuWidgetButton(text: 'Profile',image: Images.person,isSelected: currentTabIndex==1),
                        foreground: menuWidgetButton(text: 'Profile',image: Images.person,isSelected: currentTabIndex==1),
                      ),
                      ToggleElement(
                        background: menuWidgetButton(text: 'Documents',image: Images.grid,isSelected: currentTabIndex==2),
                        foreground: menuWidgetButton(text: 'Documents',image: Images.grid,isSelected: currentTabIndex==2),
                      ),
                      ToggleElement(
                        background: menuWidgetButton(text: 'Shifts',image: Images.vector,isSelected: currentTabIndex==3),
                        foreground: menuWidgetButton(text: 'Shifts',image: Images.vector,isSelected: currentTabIndex==3),
                      ),
                    ],
                  thumb: Neumorphic(
                    style: const NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      color: Colors.white,
                      depth: -200,
                    ),
                    child: Container(
                      color: const Color(0xFFEFF6FF),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                ),
                  ),),
                const SizedBox(height: 10,),
                Expanded(
                    child: Scrollbar(
                      child: ListView(
                        children: [
                          tabBarWidgetList[currentTabIndex],
                        ],
                      ),
                    )
                ),
              ],
            ),
          )),
    );
  }

  Widget menuWidgetButton({required String image, required String text,bool isSelected = false}){
    return Center(
      child: Neumorphic(
        style: const NeumorphicStyle(
          shape: NeumorphicShape.convex,
          color: Colors.transparent,
          surfaceIntensity: 0,
          depth: 00,
        ),
        drawSurfaceAboveChild:false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                image,
              height: 16,
                width: 16,
              color: isSelected ?const Color(0xFF1554F6): const Color(0xFF3C3E45),
            ),
            const SizedBox(width: 5,),
            Text(
                text,
              style: isSelected? montserratSemiBold.copyWith(fontSize: 12):montserratRegular.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

}