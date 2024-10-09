import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

class ListElement extends StatefulWidget {
  const ListElement({super.key});

  @override
  State<ListElement> createState() => _ListElementState();
}

class _ListElementState extends State<ListElement> {
  bool isReadMore = false;
  Future<List<Launch>> fetchAllLaunches() async {
    final response = await http.get(Uri.parse('https://api.spacexdata.com/v3/missions'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((launch) => Launch.fromJson(launch)).toList();
    } else {
      throw Exception('Failed to load missions');
    }
  }

  Widget buildText(String text){
    final lines = isReadMore ? null : 1;
    return Text(
      text,
      style: GoogleFonts.openSans(fontSize: 13, color: Colors.grey),
      maxLines: lines,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Launch>>(
        future: fetchAllLaunches(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Text('Error');
          } else if (!snapshot.hasData) {
            return const CircularProgressIndicator(); // Display loader if no data
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final launch = snapshot.data![index];
                return Card(
                  key: ValueKey(index),
                  margin: const EdgeInsets.all(8.0),
                  shadowColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    launch.missionName.toString(),
                                    style: GoogleFonts.openSans(fontSize: 25),
                                  ),
                                  buildText(launch.description.toString()),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
                                      onPressed: (){
                                    setState(() {
                                      isReadMore = !isReadMore;
                                    });},
                                      child: Text((isReadMore ? 'Less' : 'More')),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.center,
                          child: Wrap(
                            spacing: 20.0, // space between the chips
                            runSpacing: 13.0, // space between rows if chips overflow
                            children: launch.payloadIds!.map((payloadId) {
                              return Chip(
                                elevation: 20,
                                padding: const EdgeInsets.all(8),
                                backgroundColor: Color.fromARGB(
                                    255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256)
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                label: Text(
                                  payloadId,
                                  style: GoogleFonts.openSans(fontSize: 15, color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Launch {
  String? missionName;
  String? missionId;
  List<String>? manufacturers;
  List<String>? payloadIds;
  String? wikipedia;
  String? website;
  String? twitter;
  String? description;

  Launch({this.missionName, this.missionId, this.manufacturers, this.payloadIds, this.wikipedia, this.website, this.twitter, this.description});

  Launch.fromJson(Map<String, dynamic> json) {
    missionName = json['mission_name'];
    missionId = json['mission_id'];
    manufacturers = json['manufacturers'].cast<String>();
    payloadIds = json['payload_ids'].cast<String>();
    wikipedia = json['wikipedia'];
    website = json['website'];
    twitter = json['twitter'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mission_name'] = this.missionName;
    data['mission_id'] = this.missionId;
    data['manufacturers'] = this.manufacturers;
    data['payload_ids'] = this.payloadIds;
    data['wikipedia'] = this.wikipedia;
    data['website'] = this.website;
    data['twitter'] = this.twitter;
    data['description'] = this.description;
    return data;
  }
}
