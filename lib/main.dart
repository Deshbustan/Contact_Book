import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/new-contact': (context) => const NewContactView(),
      },
      home: const HomePage(),
  )
  );
}

class contact{
 final String name;
  contact({required this.name});
}

class ContactBook{
  ContactBook._sharedInstance();
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  final List<contact> _contacts = [];
  int get length=> _contacts.length;
  void add({required contact contact}){
    _contacts.add(contact);
  }
  void remove({required contact contact}){
    _contacts.remove(contact);
  }

  contact? contactAtIndex({required int index}) => _contacts.length > index ? _contacts[index] : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: ListView.builder(
        itemCount: contactBook.length,
        itemBuilder: (context, index) {
          final contact = contactBook.contactAtIndex(index: index);
          return ListTile();

        }, //item builder
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/new-contact');
        },
        child: const Icon(Icons.add),
        ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => NewContactViewState();
}

class NewContactViewState extends State<NewContactView> {
  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new Contact'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter a contact name...',
            ),
          ),
          TextButton(
            onPressed: () {
              final contactName = _controller.text;
              if (contactName.isNotEmpty) {
                final newContact = contact(name: contactName);
                ContactBook().add(contact: newContact);
                Navigator.pop(context);
              }
            },
            child: const Text('Add Contact'),
          )
        ],
      ),

    );
  }
}
