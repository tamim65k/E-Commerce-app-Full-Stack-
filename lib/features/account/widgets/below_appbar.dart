import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BelowAppbar extends StatelessWidget {
  const BelowAppbar({super.key});

  String formatUserName(String fullName) {
  List<String> nameParts = fullName.split(' ');

  String firstName = nameParts.first;
  String formattedFirstName = '${firstName[0].toUpperCase()}${firstName.substring(1).toLowerCase()}';

  List<String> capitalizedParts = nameParts.skip(1).map((word) {
    return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
  }).toList();

  return '$formattedFirstName ${capitalizedParts.join(' ')} !';
}



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Container(
      decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
      child: Padding(
        padding: const EdgeInsets.only(left: 20,bottom: 5),
        child: Row(
          children: [
            RichText(
              text: TextSpan(
                text: 'Hello ',
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
              
            ),
            RichText(
              text: TextSpan(
                text: formatUserName(user.name), // Use the formatUserName function to format the name
                // text: '${user.name.split(' ').first[0].toUpperCase()}${user.name.split(' ').first.substring(1).toLowerCase()} !',
                // text: '${user.name.split(' ').first.toUpperCase()}!',
                style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
