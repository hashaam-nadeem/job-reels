import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/data/model/response/post.dart';
import 'package:jobreels/util/app_constants.dart';
import 'package:jobreels/util/app_strings.dart';
import 'package:jobreels/util/images.dart';
import 'package:jobreels/util/styles.dart';
import 'package:jobreels/view/base/custom_button.dart';
import 'package:jobreels/view/base/custom_loader.dart';
import '../../../controller/post_controller.dart';
import '../../base/custom_drop_down_item.dart';
import '../../base/search_input_field.dart';
import '../../base/video_thumnail_layout.dart';
import '../home/home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  bool showSearchForm = false;
  final searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final _textFieldBackgroundColor = Colors.black.withOpacity(0.05);
  List<Post> searchedVideos = <Post>[];
  bool isLoading = true;
  bool refreshing = false;
  final double fieldHeight = 40;
  BorderRadius fieldBorderRadius = BorderRadius.circular(5);
  String ?howMuchExperience;
  String ?availability;
  Skill ?skill;
  int selectedSkillIndex = -1;
  List<CustomDropdownMenuItem<dynamic>> skillsDropDownList = <CustomDropdownMenuItem<dynamic>>[];
  final GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();


  @override
  void initState() {
    skillsDropDownList.add(
        CustomDropdownMenuItem(
          value: 'Any skill',
          child: Row(
            children: [
              Flexible(child: Text('Any skill', style: montserratRegular, overflow: TextOverflow.ellipsis, maxLines: 2,)),
            ],
          ),
        )
    );
    skillsDropDownList.addAll(
        skillList.map((skill) => CustomDropdownMenuItem(
          value: skill,
          child: Row(
            children: [
              Flexible(child: Text(skill.value, style: montserratRegular, overflow: TextOverflow.ellipsis, maxLines: 2,)),
            ],
          ),
        )).toList()
    );
    getSearchData(isFromInitState: true);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Material(
                elevation: 6,
                shadowColor: const Color(0x20696969),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: GestureDetector(
                    onTap: onShowSearchFilterForm,
                    child: Container(
                      width: double.infinity,
                      height: fieldHeight,
                      decoration: BoxDecoration(
                        borderRadius: fieldBorderRadius,
                        color: _textFieldBackgroundColor,
                      ),
                      padding: const EdgeInsets.only(left: 16,top: 2,bottom: 2,right: 2),
                      child: Row(
                        children: [
                          Image.asset(Images.search,width: 20,color: Colors.black54,filterQuality: FilterQuality.high,),
                          const SizedBox(width: 6),
                          Expanded(
                            child: SearchCustomInputTextField(
                              controller: searchController,
                              width: double.infinity,
                              focusNode: searchFocusNode,
                              onTap: onShowSearchFilterForm,
                              context: context,
                              hintText: 'Search by title, bio or experience',
                              backgroundShadow: Colors.transparent,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (showSearchForm) ...[
                const SizedBox(height: 10,),
                Container(
                  height: fieldHeight,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _textFieldBackgroundColor,
                    borderRadius: fieldBorderRadius,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomDropDown(
                          maxListHeight: howMuchExperienceDropDownList.length * 40,
                          items: howMuchExperienceDropDownList.map((e) => CustomDropdownMenuItem(
                            value: e,
                            child: Text(e, style: montserratRegular,),
                          )).toList(),
                          hintText: "How many years of experience",
                          borderRadius: 5,
                          defaultSelectedIndex: howMuchExperience!=null ? howMuchExperienceDropDownList.indexOf(howMuchExperience!):-1,
                          onChanged: (int index, dynamic val) {
                            howMuchExperience = val;
                          },
                        ),
                      ),
                      // Add other dropdowns and text fields
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: fieldHeight,
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _textFieldBackgroundColor,
                          borderRadius: fieldBorderRadius,
                        ),
                        child: CustomDropDown(
                          maxListHeight: context.height * 0.35,
                          items: skillsDropDownList,
                          hintText: "Skill",
                          borderRadius: 5,
                          defaultSelectedIndex: selectedSkillIndex,
                          onChanged: (int index, dynamic val) {
                            selectedSkillIndex = index;
                            if(val.runtimeType == Skill){
                              skill = val;
                            }else{
                              skill = null;
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Container(
                        height: fieldHeight,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _textFieldBackgroundColor,
                          borderRadius: fieldBorderRadius,
                        ),
                        child: CustomDropDown(
                          maxListHeight: availabilityFilterList.length * 40,
                          items: availabilityFilterList.map((e) => CustomDropdownMenuItem(
                            value: e,
                            child: Text(e, style: montserratRegular,),
                          )).toList(),
                          defaultSelectedIndex: availability!=null ? availabilityFilterList.indexOf(availability!):-1,
                          hintText: "Availability",
                          borderRadius: 5,
                          onChanged: (int index, dynamic val){
                            availability = val;
                          },
                        ),
                      ),
                    ),
                    // Add other dropdowns and text fields
                  ],
                ),
                const SizedBox(height: 10,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: (){
                            searchFocusNode.unfocus();
                            getSearchData();
                          },
                          height: 40,
                          buttonText: AppString.searchBy,
                        ),
                      ),
                      const SizedBox(width: 10,),
                      InkWell(
                        onTap: (){
                          setState(() {
                            searchFocusNode.unfocus();
                            showSearchForm = false;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.arrow_upward, color: Theme.of(context).primaryColorDark,size: 20,),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Divider(
                  color: Theme.of(context).primaryColorDark.withOpacity(0.8),
                ),
              ],
              if (isLoading)
                 SizedBox(height: context.height*0.55, child: const Center(child: CustomLoader()))
              else
                RefreshIndicator(
                  onRefresh: ()async{
                    await handleRefresh();
                  },
                  child: searchedVideos.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: searchedVideos.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.57, // Adjust the aspect ratio as needed
                          ),
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: (){
                              Get.to(()=> HomeScreen(postListToRender: searchedVideos,initialPage: index,title: 'Search',));
                            },
                            child: VideoGridSearch(post: searchedVideos[index]),
                          ),
                        )
                      : SizedBox(
                        width: context.width * 0.94,
                        child: Text(
                          ' There are no available job seekers that match your search criteria. Please broaden your search parameters for better results',
                          textAlign: TextAlign.center,
                          style: montserratRegular.copyWith(
                            color: const Color(0xFFe60909),
                            fontSize: 20,
                          ),
                        ),
                      )
                ),
            ],
          ),
        ),
      ),
    );
  }

  handleRefresh() async{
    await getSearchData();
  }

  getSearchData({bool isFromInitState = false}) async{
    isLoading = true;
    if(!isFromInitState){
      setState(() {});
    }
    await Get.find<PostsController>().getSearchFilteredResult(skill?.value ?? '', availability!=null && !availability!.contains('Any') ? availability! : '', howMuchExperience ?? '', searchController.text.trim()).then((List<Post> searchedPosts){
      searchedVideos.clear();
      searchedVideos.addAll(searchedPosts);
    });
    isLoading = false;
    setState(() {});
  }

  void handleSubmit() {
    getSearchData();
  }

  void onShowSearchFilterForm(){
    setState(() {
      showSearchForm = true;
      searchFocusNode.requestFocus();
    });
  }
}