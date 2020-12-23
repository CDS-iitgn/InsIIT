import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Representative {
  String position;
  String description;
  List profiles;

  Representative({this.position, this.description, this.profiles});

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      throw 'Could not launch $command';
    }
  }

  Widget profileLink(context, contactJson) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    minRadius: 18,
                    child: ClipOval(
                        child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: 75.0,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      height: 75.0,
                      imageUrl: contactJson['image'],
                    )),
                  ),
                ],
              ),
              Text(
                contactJson['name'],
                style: TextStyle(
                    color: (darkMode)
                        ? primaryTextColorDarkMode
                        : primaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              Text(
                contactJson['designation'],
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: (darkMode)
                        ? primaryTextColorDarkMode
                        : primaryTextColor),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (contactJson['phno'].length > 0)
                        ? IconButton(
                            icon: Icon(
                              Icons.phone,
                              color: Colors.black.withAlpha(120),
                            ),
                            onPressed: () {
                              List phones = contactJson['phno'];
                              if (phones.length > 1) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(contactJson['name']),
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: phones.map((phone) {
                                            return ListTile(
                                                title: Text("$phone"),
                                                trailing: Icon(
                                                  Icons.phone,
                                                ),
                                                onTap: () {
                                                  launch('tel:$phone');
                                                });
                                          }).toList()),
                                    );
                                  },
                                );
                              } else {
                                launch('tel:${phones[0]}');
                              }
                            },
                          )
                        : Container(),
                    (contactJson['email'].length > 0)
                        ? IconButton(
                            icon: Icon(
                              Icons.email,
                              color: Colors.black.withAlpha(120),
                            ),
                            onPressed: () {
                              List emails = contactJson['email'];
                              if (emails.length > 1) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(contactJson['name']),
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: emails.map((email) {
                                            return ListTile(
                                                title: Text("$email"),
                                                trailing: Icon(
                                                  Icons.phone,
                                                ),
                                                onTap: () {
                                                  launch(
                                                      'mailto:$email?subject=&body=');
                                                });
                                          }).toList()),
                                    );
                                  },
                                );
                              } else {
                                launch('mailto:${emails[0]}?subject=&body=');
                              }
                            },
                          )
                        : Container(),
                  ]),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget profileCard(context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Text(
          position,
          style: TextStyle(
            color: (darkMode) ? primaryTextColorDarkMode : primaryTextColor,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(
        height: 3,
      ),
      CarouselSlider(
          items:
              profiles.map((contact) => profileLink(context, contact)).toList(),
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 0.6,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
          ))
    ]);
  }
}