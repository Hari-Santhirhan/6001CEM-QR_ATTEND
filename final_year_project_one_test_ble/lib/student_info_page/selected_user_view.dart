import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SelectedUserView extends StatefulWidget {
  final String selectedName;
  final String selectedID;
  final String selectedEmail;
  final String selectedAdminEmail;
  final String selectedAdminPassword;
  const SelectedUserView({
    Key? key,
    required this.selectedName,
    required this.selectedID,
    required this.selectedEmail,
    required this.selectedAdminEmail,
    required this.selectedAdminPassword,
  }) : super(key: key);

  @override
  State<SelectedUserView> createState() => _SelectedUserViewState();
}

class _SelectedUserViewState extends State<SelectedUserView> {
  TextEditingController userNameController = TextEditingController();

  Future<void> deleteUserFromAuth() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference usersCollection = firestore.collection('users');

    try {
      print("STUDENT EMAIL" + widget.selectedEmail);
      QuerySnapshot querySnapshot = await usersCollection
          .where('email', isEqualTo: widget.selectedEmail)
          .get();

      final DocumentSnapshot userDoc2 = querySnapshot.docs[0];

      // Extract the password field from the document
      final Map<String, dynamic> userData2 =
      userDoc2.data() as Map<String, dynamic>;
      final String password2 = userData2['password'];
      print('' + password2);

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot userDoc = querySnapshot.docs[0];

        // Extract the password field from the document
        final Map<String, dynamic> userData =
            userDoc.data() as Map<String, dynamic>;
        final String password = userData['password'];
        print('' + password);
        await FirebaseAuth.instance.signOut();
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.selectedEmail,
          password: password,
        );
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.delete();
          print('User deleted successfully from Auth');
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: widget.selectedAdminEmail,
            password: widget.selectedAdminPassword,
          );
          User? user1 = FirebaseAuth.instance.currentUser;
          print('Admin Successfully Signed Back');
          print('' + user1!.uid.toString());
        } else {
          print('No user is currently signed in');
        }
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error getting user document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Change User's Name"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Current Name: ${widget.selectedName}"),
                          Text("Email Address: ${widget.selectedEmail}"),
                          TextField(
                            controller: userNameController,
                            decoration:
                                InputDecoration(labelText: "New Name of User"),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            // Reference to the Firestore collection
                            CollectionReference users =
                                FirebaseFirestore.instance.collection('users');

                            Map<String, dynamic> dataToUpdate = {
                              'name': userNameController.text,
                            };

                            // Query for the document with the matching email
                            QuerySnapshot querySnapshot = await users
                                .where('email', isEqualTo: widget.selectedEmail)
                                .get();

                            if (querySnapshot.docs.isNotEmpty) {
                              // If a matching document is found, update it
                              DocumentSnapshot documentSnapshot =
                                  querySnapshot.docs.first;
                              DocumentReference userDocument =
                                  users.doc(documentSnapshot.id);

                              // Perform the update
                              await userDocument.update(dataToUpdate);
                              print("Document successfully updated!");
                            } else {
                              print(
                                "No document found with the provided email.",
                              );
                            }
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            primary: Colors.orange,
                          ),
                          child: Text("Update Name"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            primary: Colors.cyanAccent,
                          ),
                          child: Text("Cancel"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.edit,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Delete User"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Current Name: ${widget.selectedName}"),
                          Text("Email Address: ${widget.selectedEmail}"),
                          Text(
                            "Are you REALLY sure that you want to delete"
                            "this user? This action CANNOT be undone",
                          )
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            // Delete User from Auth first
                            await deleteUserFromAuth();
                            // Reference to the Firestore collection
                            CollectionReference users =
                                FirebaseFirestore.instance.collection('users');

                            // Query for the document with the matching email
                            QuerySnapshot querySnapshot = await users
                                .where('email', isEqualTo: widget.selectedEmail)
                                .get();

                            if (querySnapshot.docs.isNotEmpty) {
                              // If a matching document is found, delete it
                              DocumentSnapshot documentSnapshot =
                                  querySnapshot.docs.first;
                              DocumentReference userDocument =
                                  users.doc(documentSnapshot.id);

                              // Perform the delete
                              await userDocument.delete();
                              print("Document successfully deleted!");
                            } else {
                              print(
                                  "No document found with the provided email.");
                            }
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            primary: Colors.orange,
                          ),
                          child: Text("Delete User"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            primary: Colors.cyanAccent,
                          ),
                          child: Text("Cancel"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 25),
                child: Text(
                  "Name:\n${widget.selectedName}",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 25),
                child: Text(
                  "Email:\n${widget.selectedEmail}",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 25),
                child: Text(
                  "ID:\n${widget.selectedID}",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
