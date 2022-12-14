import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/common/widgets/loader.dart';
import 'package:flutterwhatsappclone/models/status_model.dart';
import 'package:story_view/story_view.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status_screen';
  final Status status;

  const StatusScreen({Key? key, required this.status}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    initStoryPageItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const Loader()
          : StoryView(
              storyItems: storyItems,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }

  void initStoryPageItems() {
    storyItems.add(StoryItem.pageImage(
        url: widget.status.photoUrl, controller: controller));
  }
}
