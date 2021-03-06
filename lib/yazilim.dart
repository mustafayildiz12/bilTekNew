import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Widgets/showDialog.dart';
import 'constants/constants.dart';

late User loggedInuser;

class Yazilim extends StatefulWidget {
  const Yazilim({Key? key}) : super(key: key);

  @override
  _YazilimState createState() => _YazilimState();
}

class _YazilimState extends State<Yazilim> {
  TextEditingController _searchQueryController = TextEditingController();
  TextEditingController t1 = TextEditingController();
  bool _isSearching = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  String searchQuery = "Search query";
  TextStyle firstStyle = TextStyle(
      fontSize: 21,
      color: turuncu,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold);

  TextStyle dropStyle = TextStyle(
      fontSize: 17,
      color: turuncu,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold);

  String _value = "Yazılım Destek Hizmeti";

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  talepGonder(talep) async {
    Random random = Random();
    String r = random.nextInt(99999).toString();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    if (loggedInuser != null) {
      _firestore.collection("yazilimDestek").doc(loggedInuser.email! + r).set({
        "id": auth.currentUser!.uid,
        "talepturu": _value.toString(),
        "talep": talep,
        "isFixed": "0",
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
              child: _isSearching == false
                  ? Image(
                      image: ExactAssetImage("assets/appBar.png"),
                      height: height * 1 / 14,
                      width: width * 1 / 2,
                      alignment: Alignment.center,
                    )
                  : TextField(
                      controller: _searchQueryController,
                      decoration: InputDecoration(
                        hintText: "Arama yapın",
                      ),
                    )),
          actions: [
            _isSearching == false
                ? IconButton(
                    icon: Icon(
                      Icons.search,
                      color: turuncu,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: turuncu,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                      });
                    },
                  ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 8, right: 8, bottom: 15),
                child: Row(
                  children: [
                    Text(
                      "Yazılım Destek Talebi >",
                      style: firstStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 2, bottom: 15, right: 8, left: 8),
                child: Row(
                  children: [
                    Text(
                      "Mevcut Durum",
                      style: firstStyle,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    style: dropStyle,
                    focusColor: Colors.white,
                    dropdownColor: Colors.white,
                    value: _value,
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          "Yazılım Destek Hizmeti",
                        ),
                        value: "Yazılım Destek Hizmeti",
                      ),
                      DropdownMenuItem(
                        child: Text("Yazılım Güncelleme Talebi"),
                        value: "Yazılım Güncelleme Talebi",
                      ),
                      DropdownMenuItem(
                          child: Text("Hastane Yazlım Destek Talebi"),
                          value: "Hastane Yazlım Destek Talebi"),
                      DropdownMenuItem(
                          child: Text("Yazılım Güncelleme Talebi"),
                          value: "Yazılım Güncellemee Talebi"),
                      DropdownMenuItem(
                          child: Text("Yazılım Ek Modül Talebi"),
                          value: "Yazılım Ek Modül Talebi"),
                      DropdownMenuItem(
                          child: Text("CRM Destek Talebi"),
                          value: "CRM Destek Talebi"),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        _value = value!;
                      });
                    },
                  )
                ],
              ),
              SizedBox(
                height: height * 1 / 10,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width * 1 / 20, right: width * 1 / 20),
                child: Container(
                  height: height * 3 / 10,
                  width: width * 9 / 10,
                  decoration: BoxDecoration(
                    border: Border.all(color: turuncu, width: 2),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: t1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Talebinizi Yazın",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        labelStyle:
                            new TextStyle(color: const Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, top: 15, right: 8, bottom: 15),
                  child: Container(
                    width: width * 9 / 10,
                    height: height * 1 / 15,
                    child: ElevatedButton(
                      onPressed: () {
                        talepGonder(t1.text);
                        showMaterialDialog(
                            title: "Talebiniz Başarıyla Gönderildi",
                            content: "Talebiniz Başarıyla Gönderildi",
                            context: context);
                      },
                      child: Text('Talebi Gönder'),
                      style: ElevatedButton.styleFrom(
                        primary: turuncu,
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
