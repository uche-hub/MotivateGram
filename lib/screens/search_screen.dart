import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:motivate_gram/models/user_list.dart';
import 'package:motivate_gram/resouces/firebase_repository.dart';
import 'package:motivate_gram/screens/chatScreens/chatScreen.dart';
import 'package:motivate_gram/utils/universal_variables.dart';
import 'package:motivate_gram/widgets/custom_title.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  List<UserModel> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((User user) {
      _repository.fetchAllUser(user).then((List<UserModel> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context){
    return GradientAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: UniversalVariables.pinkColor,),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.pinkColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: "Langar",
              fontSize: 35
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: UniversalVariables.pinkColor,),
                onPressed: (){
                  WidgetsBinding.instance.addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Langar",
                fontSize: 35,
                color: Colors.grey
              )
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestion(String query){
    final List<UserModel> suggestionList = query.isEmpty
        ?[]
        : userList.where((UserModel user) {
          String _getUsername = user.username.toLowerCase();
          String _query = query.toLowerCase();
          String _getName = user.name.toLowerCase();
          bool matchesUsername = _getUsername.contains(_query);
          bool matchesName = _getName.contains(_query);

          return (matchesUsername || matchesName);
    }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        UserModel searchedUser = UserModel(
          uid: suggestionList[index].uid,
          profilePhoto: suggestionList[index].profilePhoto,
          name: suggestionList[index].name,
          username: suggestionList[index].username
        );

        return CustomTile(
          mini: false,
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  receiver: searchedUser,
                )
              )
            );
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchedUser.username,
            style: TextStyle(
              fontFamily: "Langar",
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
          subtitle: Text(
            searchedUser.name,
            style: TextStyle(
              fontFamily: "Langar",
              color: UniversalVariables.greyColor
            ),
          ),
        );
      }),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestion(query),
      ),
    );
  }
}
