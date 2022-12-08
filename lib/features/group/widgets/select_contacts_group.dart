import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/widgets/error.dart';
import 'package:flutterwhatsappclone/common/widgets/loader.dart';
import 'package:flutterwhatsappclone/features/select_contacts/controller/select_contact_controller.dart';
final selectedContactsGroupProvider=StateProvider<List<Contact>>((ref) =>[]);
class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactIndex=[];
  void selectContact(int index,Contact contact){
    if(selectedContactIndex.contains(index)){
      selectedContactIndex.remove(index);
      setState(() {
      ref.read(selectedContactsGroupProvider.state).update((state) {state.remove(contact);
      return state;});
      });
    }
    else{
      selectedContactIndex.add(index);
      setState(() {
      ref.read(selectedContactsGroupProvider.state).update((state) => [...state,contact]);
      });
    }
    // setState(() {
    // ref.read(selectedContactsGroupProvider.state).update((state) => [...state,contact]);
    // });
  }
  @override
  Widget build(BuildContext context) {
    return ref.watch(getRegisteredContactsProvider).when(
        data: (contactList) => Expanded(
              child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  var contact = contactList[index];
                  return InkWell(
                    onTap: ()=>selectContact(index,contact),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: selectedContactIndex.contains(index)?IconButton(onPressed: (){}, icon: const Icon(Icons.done)):null,
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        error: (err, trace) => ErrorScreen(error: err.toString()),
        loading: () => const Loader());
  }
}
