import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/common/widgets/loader.dart';
import 'package:flutterwhatsappclone/features/status/controller/status_controller.dart';
import 'package:flutterwhatsappclone/features/status/screens/status_screen.dart';
import 'package:flutterwhatsappclone/models/status_model.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Status>>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        debugPrint("status snapshot data: ${snapshot.hasData}");
        if(!snapshot.hasData||(snapshot.hasData&&snapshot.data!.length==0)){
          print("No STATUS");
          return const Center(child: const Text("No Status"));
        }
        return ListView.builder(
            itemBuilder: (context, index) {
              var statusData=snapshot.data![index];
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, StatusScreen.routeName,arguments: statusData);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top:4,bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          statusData.username,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            statusData.profilePic,
                          ),
                          radius: 30,
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: dividerColor, indent: 85),
                ],
              );
            }, itemCount: snapshot.data!.length);
      },
      future: ref.watch(statusControllerProvider).getStatus(context),
    );
  }
}
