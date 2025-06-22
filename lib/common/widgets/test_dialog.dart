// Test page for dialog functionality
import 'package:amazon_clone/common/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

class DialogTestPage extends StatelessWidget {
  const DialogTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Widget Test Page")),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await CustomDialog.show(context, "Test", "This is a test dialog.");
                print("Dialog dismissed");
              },
              child: const Text("Show Dialog"),
            ),
          ),
        ],
      ),
    );
  }
}
