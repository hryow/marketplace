import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: user == null
            ? Text('No user is currently signed in.')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (user.photoURL != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoURL!),
                      radius: 40,
                    ),
                  SizedBox(height: 16),
                  Text('Name: ${user.displayName ?? "Anonymous"}'),
                  Text('Email: ${user.email ?? "No email"}'),
                  // Add other info as needed
                  ElevatedButton(
                    onPressed: () {
                      final TextEditingController _controller = TextEditingController();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Change Display Name'),
                          content: TextField(
                            controller: _controller,
                            decoration: InputDecoration(labelText: 'New Display Name'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                if (user != null && _controller.text.isNotEmpty) {
                                  await user!.updateDisplayName(_controller.text);
                                  await user!.reload();
                                  Navigator.of(context).pop();
                                  (context as Element).markNeedsBuild();
                                }
                              },
                              child: Text('Save'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Change Name'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login', (route) => false);
                    }, 
                    child: Text('Logout'),
                  )
                ],
              ),
      ),
    );
  }
}
