import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/register_as_member.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/register_form.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';

class RegisterScreen extends StatefulWidget {
  

  const RegisterScreen({super.key});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //text controllers:-----------------------------------------------------------
 

  

  //focus node:-----------------------------------------------------------------
  
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  
 List<String> pageTitles = [
    "Register as Member",
    "Registration Form",
   // "Membership Details",
   // "Membership payment",
  ];

  // Create a variable to hold the current title.
  String currentTitle = "Register as Member"; 
  List<Widget> pages = [
  RegisterAsMember(), 
    
];

  @override
  void initState() {
    super.initState();
    
  }
   void openSecondPage() {
    _pageController.jumpToPage(1);
    setState(() {
      _currentPage = 1;
      currentTitle = pageTitles[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark? AppColors.darkThemeback:AppColors.lightThemeback,
      primary: true,
      appBar: CustomAppBar(
         isIcon: false,
        isProgress: true,
        step: 2,
        isBoarder: false,
        title:currentTitle,
      ),
      body: _buildBody(),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark? AppColors.darkThemeback:AppColors.lightThemeback,
      child: Stack(
        children: <Widget>[
          MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  children: <Widget>[
                    Expanded(child: _buildLeftSide()),
                    Expanded(
                      child: Column(
                        children: [
                          /*Expanded(
                            //child: _buildRightSide(),
                          ),
                          _buildSignInButton()*/
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    
                    Row(
                      children: [
                        SizedBox(
                          width: 22,
                        ),
                        Row(
                          children: List.generate(
                            2,
                            (index) => buildDot(index),
                          ),
                        ),
                        SizedBox(
                          width: 22,
                        ),
                      ],
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount:2,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                             currentTitle = pageTitles[page];
                          });
                        },
                        itemBuilder: (context, index) {
                            if (index >= 0 && index < pages.length) {
      return Column(
        children: [
          Expanded(
            child: Center(
              child: pages[index], // Display the selected widget for the page
            ),
          ),
        ],
      );
    } else {
      // Handle an index out of bounds error or display an empty container
      return Container();
    }
                        },
                      ),
                    ),
                  ],
                ),
       
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dotWidth = screenWidth * 0.76 / 2;
    if (_currentPage < 2 ) {
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 6),
          width: dotWidth,
          height:_currentPage == index? 1:0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(3),
            color: _currentPage == index
                ? AppColors.dotColor
                : AppColors.nondotcolor,
          ));
    } else {
      // Return an empty container for the last page to hide the dot
      return Container();
    }
  }

  Widget _buildLeftSide() {
    return Container(
      width: 300,
     
    );
  }

  

  // General Methods:-----------------------------------------------------------
  

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
  
    _pageController.dispose();
    super.dispose();
  }
}
