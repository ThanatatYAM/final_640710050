import 'dart:convert';

import 'package:final_640710050/helpers/api_caller.dart';
import 'package:final_640710050/helpers/dialog_utils.dart';
import 'package:final_640710050/helpers/my_list_tile.dart';
import 'package:final_640710050/helpers/my_text_field.dart';
import 'package:final_640710050/models/web_types.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WebTypes> _webTypes = [];

  var urlController = TextEditingController();
  var descriptionController = TextEditingController();
  String type = "";
  @override
  void initState() {
    super.initState();
    _loadWebTypes();
  }

  Future<void> _loadWebTypes() async {
    try {
      final data = await ApiCaller().get("web_types");
      List list = jsonDecode(data);
      setState(() {
        _webTypes = list.map((e) => WebTypes.fromJson(e)).toList();
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Center(child: Text("Webby Fondue")),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Text("* ต้องกรอกข้อมูล")),
            SizedBox(height: 16.0),
            Column(children: [
              MyTextField(
                controller: urlController,
                hintText: "URL *",
                keyboardType: TextInputType.url,
              ),
              SizedBox(
                height: 8.0,
              ),
              MyTextField(
                controller: descriptionController,
                hintText: "รายละอียด",
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: 16.0)
            ]),
            Text("ระบุประเภทเว็บ *"),
            Expanded(
                child: ListView.builder(
              itemCount: _webTypes.length,
              itemBuilder: (context, Index) {
                final item = _webTypes[Index];
                return Card(
                    child: MyListTile(
                  imageUrl: 'https://cpsu-api-49b593d4e146.herokuapp.com' +
                      item.image,
                  title: item.title,
                  subtitle: item.subtitle,
                  selected: type == item.id,
                  onTap: () {
                    setState(() {
                      type = item.id;
                    });
                  },
                ));
              },
            )),
            ElevatedButton(
              onPressed: _handleApiPost,
              child: const Text('ส่งข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleApiPost() async {
    try {
      final data = await ApiCaller().post(
        "report_web",
        params: {
          "id": 2,
          "url": urlController.text,
          "description": descriptionController.text,
          "type": type,
        },
      );

      Map map = jsonDecode(data);
      String text =
          'ขอบคุณสำหรับการส่งข้อมูล\n\n - เว็บพนัน: ${map['count']} \n - เว็บปลอมแปลง เลียนแบบ: ${map['count']} \n - เว็บข่าวมั่วซั่ว: ${map['count']} \n - เว็บเเชร์ลูกโซ่:${map['count']} \n - อื่นๆ: ${map['count']}';
      showOkDialog(context: context, title: "Success", message: text);
    } on Exception catch (e) {
      if (urlController.text == "") {
        showOkDialog(
            context: context, title: "Error", message: "กรุณากรอกข้อมูล URL");
      } else if (type == "") {
        showOkDialog(
            context: context, title: "Error", message: "กรุณาระบุประเภทเว็บ");
      }
    }
  }
}
