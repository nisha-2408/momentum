import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resolution_tracker/providers/auth.dart';

class ProfileBannerCard extends StatelessWidget {
  final String userName;
  final String avatar;
  final String userId;
  final Function(String newAvatar) onAvatarSelected;

  const ProfileBannerCard({
    super.key,
    required this.userName,
    required this.avatar,
    required this.userId,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2D2D2D),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        // Get the position of the tap
                        final RenderBox overlay = Overlay.of(context)
                            .context
                            .findRenderObject() as RenderBox;
                        final Offset tapPosition = details.globalPosition;

                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            tapPosition.dx, // X position
                            tapPosition.dy, // Y position
                            overlay.size.width -
                                tapPosition.dx, // Remaining space on the right
                            0, // Bottom
                          ),
                          items: [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit Avatar'),
                            ),
                            const PopupMenuItem(
                              value: 'logout',
                              child: Text('Log Out'),
                            ),
                          ],
                        ).then((value) async {
                          if (value == 'edit') {
                            // Show avatar selection dialog
                            _showAvatarDialog(context);
                          } else if (value == 'logout') {
                            // Handle Log Out logic here
                            await Provider.of<Auth>(context, listen: false)
                                .logOut();
                          }
                        });
                      },
                      child: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            avatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/notification');
              },
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  Icons.notifications,
                  size: 24.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showAvatarDialog(BuildContext context) {
    int? selectedAvatarIndex; // State variable to track selected avatar

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Choose an Avatar',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of avatars per row
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: 5, // Total number of avatars
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {
                            // Update selected avatar index
                            setState(() {
                              selectedAvatarIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedAvatarIndex == index
                                  ? Theme.of(context).primaryColor
                                  : Colors
                                      .grey[850], // Highlight selected avatar
                              shape: BoxShape
                                  .circle, // Makes the container circular
                              border: Border.all(
                                color: selectedAvatarIndex == index
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 2.0, // Border width
                              ),
                            ),
                            padding: const EdgeInsets.all(
                                8), // Padding inside the container
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/avatar${index + 1}.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: selectedAvatarIndex != null
                              ? () async {
                                  // Handle avatar selection logic here
                                  print(
                                      'Avatar ${selectedAvatarIndex! + 1} selected');
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userId)
                                      .update({
                                    'avatar':
                                        'assets/images/avatar${selectedAvatarIndex! + 1}.png'
                                  });
                                  onAvatarSelected(
                                      'assets/images/avatar${selectedAvatarIndex! + 1}.png');
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                }
                              : null, // Disable button if no avatar is selected
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
