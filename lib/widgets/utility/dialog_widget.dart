import 'package:flutter/material.dart';

import '../main_screen.dart';

Widget buildActionButton(BuildContext context, String text) {
  return SizedBox(
    width: (MediaQuery.of(context).size.width - 32) / 2 - 50,
    height: 45,
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

//* https://medium.flutterdevs.com/animate-dialogs-in-flutter-b7cac136e1d3 (Scale Dialog)
Future buildDialog(BuildContext context) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (ctx, animation1, animation2) {
      return Container();
    },
    transitionBuilder: (ctx, animation1, animation2, child) {
      var curve = Curves.easeInOut.transform(animation1.value);
      return Transform.scale(
        scale: curve,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          actionsPadding: EdgeInsets.zero,
          title: Column(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Informed Consent',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
            ],
          ),
          content: const Text(
            'Aplikasi ini mengambil informasi foto wajah dan kulit anda. Informasi tersebut dikumpulkan oleh UII Skin Analyzer dan diperlukan agar aplikasi ini dapat bekerja. Data anda tidak dapat dilihat oleh pengguna lain.\n\nSaya setuju aplikasi UII Skin Analyzer memproses informasi saya agar aplikasi ini dapat bekerja, seperti yang dijelaskan di atas. Saya mengerti bahwa respon saya akan disimpan oleh aplikasi ini. Saya berumur 12-60 tahun.\n\nJika anda tidak ingin memberikan informasi personal anda, maka sebaiknya anda tidak menggunakan aplikasi ini karena informasi tersebut dibutuhkan agar aplikasi ini dapat bekerja.',
            textAlign: TextAlign.justify,
          ),
          actions: <Widget>[
            Column(
              children: [
                const Divider(
                  color: Colors.grey,
                  height: 1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: buildActionButton(context, 'Tidak Setuju'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(); //* Hack, if not added, the navigator will not completely clean the route
                        Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
                      },
                      child: buildActionButton(context, 'Setuju'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
