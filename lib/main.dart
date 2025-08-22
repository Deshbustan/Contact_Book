import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
 final String id;
 final String name;
contact({required this.name}) : id = const Uuid().v4();
}

class ContactBook extends ValueNotifier<List<contact>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  final List<contact> _contacts = [];
  int get length=> value.length;
  void add({required contact contact}){

    final contacts =value;
    contacts.add(contact);
    notifyListeners();
  }
  void remove({required contact contact}){

    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);
    notifyListeners();
    } else {
      throw Exception('Contact not found');
    }
    
  }

  contact? contactAtIndex({required int index}) => value.length > index ? value[index] : null;
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
      body: ValueListenableBuilder(
        valueListenable: contactBook,
        builder: (context, value, child) {
          final contacts = value as List<contact>;
          return ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Dismissible(
            onDismissed: (direction) => contactBook.remove(contact: contact),
            key: ValueKey(contact.id),
            child: Material(
              color: Colors.white,
              elevation: 6.0, 
              child: ListTile(
                title: Text(contact.name),
          )
          ),
          );
        },
          );
        },
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
