import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_wings/db/db_services.dart';
import 'package:safe_wings/model/contactsm.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    askPermissions();
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  void filterContact() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = element.displayName?.toLowerCase() ?? '';
        bool nameMatch = contactName.contains(searchTerm);

        if (nameMatch) {
          return true;
        }

        if (searchTermFlatten.isNotEmpty) {
          for (var phone in element.phones!) {
            String phoneFlattened = flattenPhoneNumber(phone.value!);
            if (phoneFlattened.contains(searchTermFlatten)) {
              return true;
            }
          }
        }

        return false;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermission();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
      searchController.addListener(() {
        filterContact();
      });
    } else {
      handleInvalidPermissions(permissionStatus);
    }
  }

  void handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Permission Denied"),
          content: Text("Access to contacts denied by the user."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Permission Permanently Denied"),
          content: Text("Contacts permission is permanently denied."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Future<PermissionStatus> getContactsPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void getAllContacts() async {
    List<Contact> _contacts =
    await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemExists = (contactsFiltered.isNotEmpty || contacts.isNotEmpty);
    return Scaffold(
      body: contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Search contact",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            listItemExists
                ? Expanded(
              child: ListView.builder(
                itemCount: isSearching
                    ? contactsFiltered.length
                    : contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = isSearching
                      ? contactsFiltered[index]
                      : contacts[index];
                  return ListTile(
                    title: Text(contact.displayName ?? 'No name'),
                    leading: (contact.avatar != null &&
                        contact.avatar!.isNotEmpty)
                        ? CircleAvatar(
                      backgroundColor: Colors.pink[400],
                      backgroundImage:
                      MemoryImage(contact.avatar!),
                    )
                        : CircleAvatar(
                      backgroundColor: Colors.pink[400],
                      child: Text(contact.initials()),
                    ),
                    onTap: () {
                      if (contact.phones!.length>0) {
                        final String phoneNum =
                        contact.phones!.elementAt(0).value!;
                        final String name =
                            contact.displayName ?? 'No name';
                        _addContact(TContact(phoneNum, name));
                      } else {
                        Fluttertoast.showToast(
                            msg: "This contact has no phone number");
                      }
                    },
                  );
                },
              ),
            )
                : Container(
              child: Text("No contacts found"),
            ),
          ],
        ),
      ),
    );
  }

  void _addContact(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contact");
    }
    Navigator.of(context).pop(true);
  }
}

