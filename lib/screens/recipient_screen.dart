import 'package:charityapp/models/donation.dart';
import 'package:charityapp/screens/item_details.dart';
import 'package:charityapp/screens/request_form.dart';
import 'package:charityapp/widgets/app_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipientScreen extends StatefulWidget {
  static const String id = 'recipient_screen';
  @override
  _RecipientScreenState createState() => _RecipientScreenState();
}

class _RecipientScreenState extends State<RecipientScreen> {
  final key = GlobalKey<ScaffoldState>();
  final Firestore _db = Firestore.instance;
  List<Donation> donations;
  bool _isLoading;

  getDonations() async {
    var data = await _db.collection('donations').getDocuments();
    print(data.documents.length);
    if (data.documents.length != 0) {
      setState(() {
        donations = data.documents
            .map((doc) => Donation.fromMap(doc.data, doc.documentID))
            .toList();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _isLoading = true;
    getDonations();
    super.initState();
  }

  Widget donationCard(Donation donation) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ItemDetails(donation: donation, type: 'donation'),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    donation.img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                donation.name.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text('Charity App'),
        centerTitle: true,
        backgroundColor: Color(0xFF42906A),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: SearchBar(donations: donations));
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'People Donations',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: Color(0xFF42906A),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, RequestForm.id);
                              },
                              iconSize: 50,
                            ),
                            Text(
                              'add request',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: donations != null
                        ? GridView.builder(
                            shrinkWrap: true,
                            itemCount: donations.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int i) {
                              return donationCard(donations[i]);
                            },
                          )
                        : Center(
                            child: Text('No Donations'),
                          ),
                  )
                ],
              ),
            ),
    );
  }
}

class SearchBar extends SearchDelegate<Donation> {
  SearchBar({@required this.donations});
  final List<Donation> donations;

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.black,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Donation> myList = query.isEmpty
        ? donations
        : donations
            .where((e) =>
                (e.name.toLowerCase().startsWith(query.toLowerCase()) || e.donorAddress.toLowerCase().startsWith(query.toLowerCase())))
            .toList();
    return ListView.builder(
      itemCount: myList.length,
      itemBuilder: (context, i) {
        return ListTile(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ItemDetails(donation: myList[i], type: 'donation'),
              ),
            );
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                myList[i].name.toUpperCase(),
                style: TextStyle(fontSize: 20),
              ),
              Text(
                myList[i].donorAddress.toUpperCase(),
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
