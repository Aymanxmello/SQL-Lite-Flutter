import 'package:flutter/material.dart';

void main() {
  runApp(const ContactsApp());
}

class ContactsApp extends StatelessWidget {
  const ContactsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
          fontFamily: 'Roboto',
      ),
      home: const ContactsHomePage(),
    );
  }
}

// ─── Model ───────────────────────────────────────────────────────────────────

class Contact {
  final String name;
  final String phone;
  const Contact({required this.name, required this.phone});
}

// ─── Home Page ────────────────────────────────────────────────────────────────

class ContactsHomePage extends StatefulWidget {
  const ContactsHomePage({super.key});

  @override
  State<ContactsHomePage> createState() => _ContactsHomePageState();
}

class _ContactsHomePageState extends State<ContactsHomePage> {
  final List<Contact> _contacts = [
    const Contact(name: 'Alice Martin', phone: '+1 555-0101'),
    const Contact(name: 'Bob Johnson', phone: '+1 555-0102'),
    const Contact(name: 'Carol White', phone: '+1 555-0103'),
    const Contact(name: 'David Brown', phone: '+1 555-0104'),
    const Contact(name: 'Eva Green', phone: '+1 555-0105'),
  ];

  void _addContact(String name, String phone) {
    setState(() {
      _contacts.add(Contact(name: name, phone: phone));
      _contacts.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty &&
                  phoneController.text.trim().isNotEmpty) {
                _addContact(
                  nameController.text.trim(),
                  phoneController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Color _avatarColor(String name) {
    final colors = [
      const Color(0xFF6750A4),
      const Color(0xFF7965AF),
      const Color(0xFF0061A4),
      const Color(0xFF006E1C),
      const Color(0xFF984061),
      const Color(0xFF8B4513),
      const Color(0xFF006B5E),
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      // ── AppBar (Scaffold title) ──────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surfaceTint,
        title: const Text(
          'Contacts',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More options',
            onPressed: () {},
          ),
        ],
      ),

      // ── Body: RecyclerView-style ListView ────────────────────────────────
      body: _contacts.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.contacts_outlined,
                      size: 72, color: scheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text('No contacts yet',
                      style: TextStyle(color: scheme.onSurfaceVariant)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                final initials = contact.name
                    .split(' ')
                    .where((w) => w.isNotEmpty)
                    .take(2)
                    .map((w) => w[0].toUpperCase())
                    .join();

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _avatarColor(contact.name),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    contact.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(contact.phone),
                  trailing: IconButton(
                    icon: Icon(Icons.phone, color: scheme.primary),
                    onPressed: () {},
                  ),
                  onTap: () {},
                );
              },
            ),

      // ── FAB with + icon ──────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        tooltip: 'Add Contact',
        child: const Icon(Icons.add),
      ),
    );
  }
}