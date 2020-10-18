import 'package:charityapp/models/request.dart';
import 'package:charityapp/screens/root_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'item_details.dart';

class RecipientsList extends StatefulWidget {
  static const String id = 'recipient_list';
  @override
  _RecipientsListState createState() => _RecipientsListState();
}

class _RecipientsListState extends State<RecipientsList> {
  final Firestore _db = Firestore.instance;
  List<Request> requests;
  bool isLoading = false;

  getRequests() async {
    var data = await _db.collection('requests').getDocuments();
    print(data.documents.length);
    if (data.documents.length != 0) {
      setState(() {
        requests = data.documents
            .map((doc) => Request.fromMap(doc.data, doc.documentID))
            .toList();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    isLoading = true;
    getRequests();
    super.initState();
  }

  showCircularProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipients List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF42906A),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 15,
          ),
          onPressed: () {
            Navigator.pushNamed(context, RootPage.id);
          },
        ),
      ),
      body: isLoading
          ? showCircularProgress()
          : requests == null
              ? Center(
                  child: Text('No Requests'),
                )
              : ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (BuildContext context, int i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ItemDetails(request: requests[i], type: 'request'),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text('Request ${i+1}'),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  },
                ),
    );
  }
}
