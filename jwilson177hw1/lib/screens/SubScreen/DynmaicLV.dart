import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jwilson177hw1/services/adminalert.dart';
import 'package:jwilson177hw1/services/auth.dart';

String other = '';
String search = '';

class DynamicLV extends StatefulWidget {
  @override
  _DynamicLVState createState() => _DynamicLVState();
}

class _DynamicLVState extends State<DynamicLV> {
  AdminAlert db = new AdminAlert();
  var arr = [];
  String msg = '';
  final controller = ScrollController();
  String cur = '';
  String img = '';
  @override
  Widget build(BuildContext context) {
    Future<String> msgs = db.getBoardsAsString();
    Future<String> current_user = db.currentuid();
    current_user.then((value) => setState(() {
          cur = value;
        }));
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
          var boardid = arr[reversedIndex];
          // print(boardid + "BID");
          if (boardid == 'cards') {
            img = 'assets/cards.jpg';
            // print(msg);
          } else if (boardid == 'sports') {
            img = 'assets/sports.jpg';
            // print(msg);
          } else if (boardid == 'cars') {
            img = 'assets/cars.jpg';
            // print(msg);
          } else if (boardid == 'electronic devices') {
            img = 'assets/edev.jpg';
            // print(msg);
          } else if (boardid == 'games') {
            img = 'assets/games.jpg';
            // print(msg);
          }

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(img),
                fit: BoxFit.fill,
              ),
            ),
            child: InkWell(
              child: new Text(
                arr[reversedIndex] + "\n\n",
                style: TextStyle(
                  color: Colors.lime,
                  fontSize: 29,
                ),
              ),
              onTap: () {
                other = boardid;
                print(other);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Conversation()),
                );
                // db.createChat("Open", userid + cur);
              },
            ),
          );
        });
  }
}

class DynamicLVC extends StatefulWidget {
  const DynamicLVC({
    Key? key,
  }) : super(key: key);
  @override
  _DynamicLVCState createState() => _DynamicLVCState();
}

class _DynamicLVCState extends State<DynamicLVC> {
  AdminAlert db = new AdminAlert();
  var arr = [];
  String msg = '';
  String cur = '';
  bool chatexists = false;
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Future<String> current_user = db.currentuid();
    current_user.then((value) => setState(() {
          cur = value;
        }));
    Future<String> msgs = db.getMessagesAsString(other, search);
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

          return Container(
            child: ListTile(
              title: new Text(arr[reversedIndex]),
              onTap: () async {
                db.addItem(arr[reversedIndex], cur);
              },
            ),
          );
        });
  }
}

class Conversation extends StatefulWidget {
  const Conversation({Key? key}) : super(key: key);

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController _searchcontroller = TextEditingController();
  String message = '';
  String msg = '';
  String current_user = '';
  String name = '';
  String docid = '';
  String condition = '';
  String price = '';
  String itemname = '';

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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(other),
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: TextFormField(
                  validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                  decoration: InputDecoration(
                      hintText: 'item name', helperText: 'enter item name'),
                  onChanged: (v) => {itemname = v},
                ),
              ),
              Container(
                child: TextFormField(
                  validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                  decoration: InputDecoration(
                      hintText: 'item price', helperText: 'enter item price'),
                  onChanged: (v) => {price = v},
                ),
              ),
              Container(
                child: TextFormField(
                  validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                  decoration: InputDecoration(
                      hintText: 'Enter condition',
                      helperText: 'Condition of item'),
                  onChanged: (v) => {condition = v},
                ),
              ),
              ElevatedButton(
                  child: Text('Add new item'),
                  onPressed: () {
                    db.addAdminMessage(itemname, price, condition, other);
                  }),
              Expanded(child: DynamicLVC()),
              Container(
                child: TextFormField(
                  controller: _searchcontroller,
                  validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                  decoration: InputDecoration(
                      hintText: 'message', helperText: 'search'),
                  onChanged: (v) => {search = v},
                ),
              ),
            ],
          ),
        ));
  }
}
