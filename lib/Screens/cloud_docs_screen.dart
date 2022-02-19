import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:project/Screens/document_details_screen.dart';
import 'package:share_plus/share_plus.dart';

class CloudDocsScreen extends StatefulWidget {
  String? authUserEmail;
  CloudDocsScreen({Key? key, this.authUserEmail}) : super(key: key);

  @override
  State<CloudDocsScreen> createState() => _CloudDocsScreenState();
}

class _CloudDocsScreenState extends State<CloudDocsScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.authUserEmail == null
        ? Container(
            child: Center(
              child: ElevatedButton(
                child: Text('Login'),
                onPressed: () => Navigator.pushNamed(context, '/login'),
              ),
            ),
          )
        : Scaffold(
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('docs')
                    .where('userEmail', isEqualTo: widget.authUserEmail)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 180,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 25,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 6.0,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Stack(
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.file_copy_outlined,
                                      size: 100,
                                      color: Colors.orange,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'FileName: \n' +
                                                snapshot.data.docs[index]
                                                    ['filename'],
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Text(
                                            'Description: \n' +
                                                snapshot.data.docs[index]
                                                    ['desc'],
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        snapshot.data.docs[index]['date']
                                            .toDate()
                                            .toString()
                                            .split(' ')[0],
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    //TODO: Delete from cloud
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Are you sure to delete this file?',
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                      primary: Colors.white,
                                                      backgroundColor:
                                                          Colors.lightGreen),
                                                  child: Text('Yes'),
                                                  onPressed: () async {
                                                    final collection =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('docs');
                                                    await collection
                                                        .doc(snapshot
                                                            .data
                                                            .docs[index]
                                                            .id) // <-- Doc ID to be deleted.
                                                        .delete() // <-- Delete
                                                        .then((_) =>
                                                            print('Deleted'))
                                                        .catchError((error) =>
                                                            print(
                                                                'Delete failed: $error'));
                                                    await FirebaseStorage
                                                        .instance
                                                        .refFromURL(snapshot
                                                                .data
                                                                .docs[index][
                                                            'docUrl']) // <-- Document Url to be deleted
                                                        .delete();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                      primary: Colors.white,
                                                      backgroundColor:
                                                          Colors.redAccent),
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 60,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () async {
                                    await Share.share(
                                      snapshot.data.docs[index]['docUrl'],
                                    );
                                  },
                                  child: Icon(
                                    Icons.share,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data.docs.length,
                  );
                }),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_home,
              children: [
                SpeedDialChild(
                    child: Icon(Icons.camera),
                    label: 'Create Cloud Doc',
                    onTap: () => showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return DocumentDetailsScreen(
                            folderPath: "",
                            authUserEmail: widget.authUserEmail,
                          );
                        })),
              ],
            ),
          );
  }
}
