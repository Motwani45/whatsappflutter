import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/widgets/error.dart';
import 'package:flutterwhatsappclone/common/widgets/loader.dart';
import 'package:flutterwhatsappclone/features/select_contacts/controller/select_contact_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = '/select_contact';

  const SelectContactScreen({Key? key}) : super(key: key);
  void selectContact(WidgetRef ref,Contact selectedContact,BuildContext context){
    ref.read(selectContactControllerProvider).selectContact(selectedContact, context);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: "Select contact".text.make(),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: ref.watch(getContactsProvider).when(data:(contactList){
        return ListView.builder(itemCount: contactList.length,itemBuilder: (context,index){
          final contact=contactList[index];
          return InkWell(
            child: ListTile(
              title: contact.displayName.text.size(18).make(),
              leading: contact.photo==null?null:CircleAvatar(
                backgroundImage: MemoryImage(contact.photo!),
                radius: 30,
              ),
            ).pOnly(bottom: 8),
            onTap: (){
              selectContact(ref, contact, context);

            },
          );
        });
      }, error:(err,stackTree){
        return ErrorScreen(error: err.toString());
      }, loading: (){
        return const Loader();
      }),
    );
  }
}
