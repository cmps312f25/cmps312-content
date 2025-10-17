import 'package:flutter/material.dart';

class MyAppBarExample extends StatelessWidget {
  const MyAppBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruits'),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'Search',
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            tooltip: 'Sort',
            icon: const Icon(Icons.sort),
          ),
        ],
        
      ),
      body: const Center(child: Text('Content')),
      
      floatingActionButton: 
      FloatingActionButton(
        onPressed: () {  },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                showDialog(
  context: context,
  builder: (context) => 
  AlertDialog(
    title: const Text('Select Ringtone'),
    content: SingleChildScrollView(  // Handle overflow
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('Default'),
              onTap: () => context.pop('Default'), // Close + return value
            ),
            ListTile(
              leading: const Icon(Icons.album),
              title: const Text('Classical'),
              onTap: () => context.pop('Classical'),
            ),
          // More options...
        ],
      ),
    ),
  ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    ],
  ),
  
  // Standard Bottom Sheet
showBottomSheet(
  context: context,
  builder: (context) => MyBottomSheet(),
);

// Modal Bottom Sheet
final result = await showModalBottomSheet(
  context: context,
  isDismissible: true,           // Tap outside to dismiss
  isScrollControlled: false,     // Full-height when true
  showDragHandle: true,          // M3 drag handle
  enableDrag: true,              // Swipe down to dismiss
  builder: (context) => MyBottomSheet(),
);

void _showSideSheet(BuildContext context, {bool modal = false}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true, // Allow tap outside to close
    // 👇 Key difference:
    barrierColor: modal ? Colors.black54 : Colors.transparent, 
    // modal → dimmed background (requires attention)
    // standard → transparent (non-blocking overlay)
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.centerRight, // Slide in from right edge
        child: Container(
          width: 300,
          color: Colors.white,
          child: const Center(
            child: Text('Side Sheet Content'),
          ),
        ),
      );
    },
  );
}


              },
            ),
          ],
        ),
      )
    );


    
  }
}
