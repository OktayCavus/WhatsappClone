import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/core/locator.dart';
import 'package:whatsapp_clone/viewmodels/sign_in_model.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditing = TextEditingController();
    return ChangeNotifierProvider(
      // ! getit üzerinden signinmodel ve signinpage'i birbirine bağladık bu şekilde
      //create: (context) => GetIt.instance<SignInModel>(),
      create: (context) => getIt<SignInModel>(),
      child: Consumer<SignInModel>(
        // ! value(model) SıgnınModel'i temsil ediyor
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Sign In For Whatsapp Clone'),
          ),
          body: Container(
            padding: const EdgeInsets.all(8),
            child: model.busy
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('User Name'),
                      TextField(
                        controller: textEditing,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await model.signInn(textEditing.text);
                          },
                          child: const Text('Sign In'))
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
