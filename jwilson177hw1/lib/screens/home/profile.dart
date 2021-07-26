import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jwilson177hw1/services/adminalert.dart';
import 'package:jwilson177hw1/services/auth.dart';
import 'package:link_text/link_text.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicLVP extends StatefulWidget {
  @override
  _DynamicLVPState createState() => _DynamicLVPState();
}

class _DynamicLVPState extends State<DynamicLVP> {
  AdminAlert db = new AdminAlert();
  var arr = [];
  String msg = '';
  final controller = ScrollController();
  String cur = '';
  String url = "https://www.ebay.com/shc";
  @override
  Widget build(BuildContext context) {
    Future<String> current_user = db.currentuid();
    current_user.then((value) => setState(() {
          cur = value;
        }));

    Future<String> msgs = db.getWatchItemAsString(cur);
    msgs.then((value) => setState(() {
          msg = value;
          // print(msg);
        }));
    arr = msg.split('\n');
    // autoadj();
    return ListView.builder(
        reverse: true,
        controller: controller,
        itemCount: arr.length,
        itemBuilder: (context, index) {
          final reversedIndex = arr.length - 1 - index;
          String item = arr[reversedIndex];
          print(item.split(" ")[0]);

          return Container(
              child: GestureDetector(
            child: InkWell(
              child: new Text(
                arr[reversedIndex] + "\n\n",
                style: TextStyle(
                  color: Colors.lime,
                  fontSize: 29,
                ),
              ),
              onTap: () {
                launch("https://www.ebay.com/sch/" + item.split(":")[0]);
              },
              onDoubleTap: () {
                launch("https://www.ebay.com/sch/i.html?_from=R40&_trksid=p2334524.m570.l1311&_nkw=" +
                    item.split(":")[0] +
                    "%2010&_sacat=0&LH_TitleDesc=0&_odkw=tom+brady+rookie+card&_osacat=0&_sop=16&LH_Complete=1&LH_Sold=1");
              },
            ),
          ));
        });
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String uid = '';
  String firstName = '';
  String social = "";
  String lastName = '';
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    AdminAlert db = new AdminAlert();

    Future<String> uzr = db.currentuid();
    uzr.then((value) => setState(() {
          uid = value;
        }));
    Future<String> soc = db.getsocial();
    soc.then((value) => setState(() {
          social = value;
        }));
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Profile Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                decoration: InputDecoration(
                    hintText: 'firstname', helperText: 'Change first name'),
                onChanged: (v) => {setState(() => firstName = v)},
              ),
              TextFormField(
                validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'last name', helperText: 'reset last name'),
                onChanged: (v) => {setState(() => lastName = v)},
              ),
              ElevatedButton(
                  child: Text('Reset Name'),
                  onPressed: () async {
                    await db.updateProfile(firstName, uid, lastName);
                  }),
              ElevatedButton(
                  child: Text('Load watch list'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WatchList()),
                    );
                  }),
              LinkText(
                social,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WatchList extends StatefulWidget {
  const WatchList({Key? key}) : super(key: key);

  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  String message = '';
  String msg = '';
  String current_user = '';
  String name = '';
  String docid = '';

  bool cexists = false;
  bool cexists1 = false;
  var arr = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth1 = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    AdminAlert db = new AdminAlert();

    Future<String> uzr = db.currentuid();
    Future<String> username = db.getUser();

    // msgs.then((value) => setState(() {
    //       msg = value;
    //     }));
    uzr.then((value) => setState(() {
          current_user = value;
        }));
    username.then((value) => setState(() {
          name = value;
        }));

    return Scaffold(
        appBar: AppBar(
          title: Text("WATCHLIST"),
          backgroundColor: Colors.greenAccent,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(child: DynamicLVP()),
              Container(
                child: TextFormField(
                  validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                  decoration: InputDecoration(
                      hintText: 'message', helperText: 'search'),
                  onChanged: (v) => {setState(() => message = v)},
                ),
              ),
              SingleChildScrollView(
                child: ElevatedButton(
                    onPressed: () async {
                      //search here
                      print("Search for" + message);
                      db.search(message);
                      FocusScope.of(context).unfocus();
                    },
                    child: Text(">Search")),
              )
            ],
          ),
        ));
  }
}
