import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CloudDocsScreen extends StatelessWidget {
  const CloudDocsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('docs').snapshots(),
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
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'FileName: \n' +
                                        snapshot.data.docs[index]['filename'],
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    'Description: \n' +
                                        snapshot.data.docs[index]['desc'],
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
                                    fontSize: 12, fontWeight: FontWeight.bold),
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
                            //TODO: Share the document URL
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
        });
  }
}
