
import 'package:beautysalon/helper/pref/sharedpref.dart';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/profile.dart';
import '/variable.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final screen_size_width = MediaQuery.of(context).size.width;
    final screen_size_height = MediaQuery.of(context).size.height;
    return Container(
      height: screen_size_height*1,
      child: ListView.builder(
          itemCount: sidebar.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                print("heyg "+sidebar[index]);
                // sidebar[index];
                if(sidebar[index].toString()=="Call to Salon"){
                  print("heysdfsf");
                  launch('tel: 9911699915');
                //  canLaunchUrl(Uri(scheme: 'tel', path: '')).then((bool result) {


                }
                if(sidebar[index]=="My Account"){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Profile(),
                  ));
                }
                if(sidebar[index]=="Share App"){
                  print("abcd");
                  Share.share('check out my website https://example.com');
                }
                if(sidebar[index]==6){
                  SharedPref().removeUser();
                }
              },
              child: ListTile(
                leading: item2[index],
                title: Text(sidebar[index]),
              ),
            );
          }
      )
      );
  }
}

 void share()  {

}