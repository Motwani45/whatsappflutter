import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/common/utils/utils.dart';
import 'package:flutterwhatsappclone/features/group/controller/group_controller.dart';
import 'package:flutterwhatsappclone/features/group/widgets/select_contacts_group.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);
  static const String routeName = '/create_group';

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  File? image;
  final TextEditingController groupNameController = TextEditingController();
  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }
  void createGroup(){
    var selectedContacts=ref.read(selectedContactsGroupProvider);
    if(groupNameController.text.trim().isNotEmpty&&image!=null&&selectedContacts.isNotEmpty){
      var name=groupNameController.text.trim();
      ref.read(groupControllerProvider).createGroup(context, name, image!, selectedContacts);
      ref.read(selectedContactsGroupProvider.state).update((state) => []);
      Navigator.pop(context);
    }
    else if(selectedContacts.isEmpty){
      showSnackBar(context: context, content:"There Should be Atleast One Contact Selected!!");
    }
    else{
      showSnackBar(context: context, content: "Name and Profile Image cannot be empty!!");
    }
  }
  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                (image == null)
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: Image.network(
                                "https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png")
                            .image,
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(image!),
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo)))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: groupNameController,
                decoration: const InputDecoration(hintText: "Enter Group Name"),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              child: const Text(
                "Select Contacts",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            const SelectContactsGroup(),
          ],

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: tabColor,
        child: const Icon(Icons.done,color: Colors.white,),
      ),
    );
  }
}
