# 🧭 Navigation

---

## 🧭 Navigation

**Widgets for app navigation**

> ![🗺️](https://img.icons8.com/color/48/000000/navigation.png)

Flutter provides comprehensive navigation widgets for moving between screens and organizing app structure. These widgets enable intuitive navigation patterns from simple page transitions to complex multi-level navigation.

---

# 🧱 App-Level Navigation

## 1️⃣ AppBar
### Overview
- **Purpose:** Top app bar displaying title, actions, and navigation controls.
- **Key Properties:** `title`, `actions`, `leading`, `backgroundColor`, `elevation`, `bottom`.
- **Events:** Action button callbacks.
- **Usage Scenarios:** Screen titles, primary actions, navigation, search, tabs.

#### Speaker Notes
- AppBar is the primary navigation and context widget at the top of screens.

---

### 2️⃣ Example
```dart
Scaffold(
  appBar: AppBar(
    title: Text('Music Library'),
    backgroundColor: Colors.deepPurple,
    elevation: 4,
    leading: IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          print('Search pressed');
        },
      ),
      IconButton(
        icon: Icon(Icons.favorite),
        onPressed: () {
          print('Favorites pressed');
        },
      ),
      PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(child: Text('Settings'), value: 'settings'),
          PopupMenuItem(child: Text('About'), value: 'about'),
        ],
        onSelected: (value) {
          print('Selected: $value');
        },
      ),
    ],
  ),
  body: Center(child: Text('Content')),
)
```

---

### 3️⃣ Best Practices
- Keep titles concise and descriptive.
- Limit actions to 2-3 most important operations.
- Use `leading` for back buttons or menu icons.
- Use `bottom` property for TabBar integration.
- Provide tooltips for action icons.
- Maintain consistent AppBar styling across the app.

#### Speaker Notes
- AppBar provides context and primary actions. Keep it clean and focused.

---

## 1️⃣ Drawer
### Overview
- **Purpose:** Side navigation panel for secondary navigation and options.
- **Key Properties:** `child` (typically ListView with DrawerHeader).
- **Events:** Item selection callbacks, drawer open/close.
- **Usage Scenarios:** Secondary navigation, settings, user profile, app sections.

#### Speaker Notes
- Drawer provides access to secondary navigation without cluttering the main UI.

---

### 2️⃣ Example
```dart
Scaffold(
  appBar: AppBar(title: Text('App')),
  drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
              SizedBox(height: 12),
              Text(
                'John Doe',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'john@example.com',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.music_note),
          title: Text('My Music'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text('Favorites'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text('Help'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  ),
  body: Center(child: Text('Content')),
)
```

---

### 3️⃣ Best Practices
- Use `DrawerHeader` for user info or branding.
- Group related items with `Divider`.
- Close drawer after selection with `Navigator.pop()`.
- Use for 5+ navigation destinations.
- Provide clear icons and labels.
- Avoid nesting too many levels.

#### Speaker Notes
- Drawer is ideal for apps with many sections without cluttering the bottom bar.

---

## 1️⃣ BottomNavigationBar
### Overview
- **Purpose:** Bottom navigation bar for primary app sections.
- **Key Properties:** `items`, `currentIndex`, `onTap`, `type`, `selectedItemColor`.
- **Events:** `onTap` for navigation.
- **Usage Scenarios:** App-level navigation (3-5 primary destinations).

#### Speaker Notes
- BottomNavigationBar provides quick access to top-level destinations.

---

### 2️⃣ Example
```dart
class BottomNavExample extends StatefulWidget {
  @override
  _BottomNavExampleState createState() => _BottomNavExampleState();
}

class _BottomNavExampleState extends State<BottomNavExample> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    Center(child: Text('Search', style: TextStyle(fontSize: 24))),
    Center(child: Text('Library', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profile', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(['Home', 'Search', 'Library', 'Profile'][_currentIndex]),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

---

### 3️⃣ Best Practices
- Use for 3-5 primary destinations.
- Use `BottomNavigationBarType.fixed` for 3-4 items.
- Use `BottomNavigationBarType.shifting` for 4-5 items with emphasis.
- Provide clear, recognizable icons.
- Keep labels short (1-2 words).
- Update content based on `currentIndex`.
- **Recommended:** Use BottomNavigationBar for primary navigation (3-5 items).

#### Speaker Notes
- BottomNavigationBar is the standard for mobile app navigation. Keep it simple and intuitive.

---

## 1️⃣ NavigationRail
### Overview
- **Purpose:** Side navigation rail for desktop/tablet layouts.
- **Key Properties:** `destinations`, `selectedIndex`, `onDestinationSelected`, `extended`, `leading`.
- **Events:** `onDestinationSelected` for navigation.
- **Usage Scenarios:** Desktop/tablet apps, wide-screen navigation, multi-pane layouts.

#### Speaker Notes
- NavigationRail provides elegant navigation for larger screens with more space.

---

### 2️⃣ Example
```dart
class NavigationRailExample extends StatefulWidget {
  @override
  _NavigationRailExampleState createState() => _NavigationRailExampleState();
}

class _NavigationRailExampleState extends State<NavigationRailExample> {
  int _selectedIndex = 0;
  bool _extended = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: _extended,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            leading: FloatingActionButton(
              elevation: 0,
              onPressed: () {
                setState(() {
                  _extended = !_extended;
                });
              },
              child: Icon(Icons.menu),
            ),
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search),
                selectedIcon: Icon(Icons.search),
                label: Text('Search'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.library_music),
                selectedIcon: Icon(Icons.library_music),
                label: Text('Library'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: Text(
                ['Home', 'Search', 'Library', 'Settings'][_selectedIndex],
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

### 3️⃣ Best Practices
- Use for desktop and tablet layouts.
- Toggle `extended` mode for text labels.
- Combine with `LayoutBuilder` for responsive switching.
- Provide `leading` widget for branding or menu.
- Use for 3-7 destinations.
- Switch to BottomNavigationBar on mobile.

#### Speaker Notes
- NavigationRail is perfect for wide screens where bottom navigation isn't ideal.

---

# 🧱 Page Navigation

## 1️⃣ PageView
### Overview
- **Purpose:** Swipeable pages with smooth transitions.
- **Key Properties:** `children`, `controller`, `scrollDirection`, `pageSnapping`, `onPageChanged`.
- **Events:** `onPageChanged` callback.
- **Usage Scenarios:** Onboarding, image galleries, tutorials, step-by-step flows.

#### Speaker Notes
- PageView provides smooth, swipeable page transitions for guided experiences.

---

### 2️⃣ Example
```dart
class PageViewExample extends StatefulWidget {
  @override
  _PageViewExampleState createState() => _PageViewExampleState();
}

class _PageViewExampleState extends State<PageViewExample> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {'title': 'Welcome', 'icon': Icons.waving_hand, 'color': Colors.blue},
    {'title': 'Discover Music', 'icon': Icons.music_note, 'color': Colors.purple},
    {'title': 'Create Playlists', 'icon': Icons.playlist_add, 'color': Colors.green},
    {'title': 'Start Listening', 'icon': Icons.headphones, 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                final page = _pages[index];
                return Container(
                  color: page['color'].withOpacity(0.2),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(page['icon'], size: 120, color: page['color']),
                        SizedBox(height: 32),
                        Text(
                          page['title'],
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _currentPage > 0
                      ? () => _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                      : null,
                  child: Text('Previous'),
                ),
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _currentPage < _pages.length - 1
                      ? () => _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                      : () => print('Get Started'),
                  child: Text(_currentPage < _pages.length - 1 ? 'Next' : 'Start'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
```

---

### 3️⃣ Best Practices
- Use `PageController` for programmatic navigation.
- Provide page indicators for orientation.
- Use for onboarding and tutorials.
- Enable `pageSnapping` for smooth transitions.
- Dispose controller properly.
- Use `PageView.builder` for large page counts.

#### Speaker Notes
- PageView is ideal for guided, linear experiences like onboarding and tutorials.

---

## 1️⃣ TabBar
### Overview
- **Purpose:** Tab navigation within a screen or AppBar.
- **Key Properties:** `tabs`, `controller`, `isScrollable`, `indicatorColor`, `labelColor`.
- **Events:** Tab selection via controller.
- **Usage Scenarios:** Section switching, categorized content, different views.

#### Speaker Notes
- TabBar provides compact navigation for multiple sections within a screen.

---

### 2️⃣ Example
```dart
class TabBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Music Categories'),
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.album), text: 'Albums'),
              Tab(icon: Icon(Icons.music_note), text: 'Songs'),
              Tab(icon: Icon(Icons.person), text: 'Artists'),
              Tab(icon: Icon(Icons.playlist_play), text: 'Playlists'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Albums', style: TextStyle(fontSize: 24))),
            Center(child: Text('Songs', style: TextStyle(fontSize: 24))),
            Center(child: Text('Artists', style: TextStyle(fontSize: 24))),
            Center(child: Text('Playlists', style: TextStyle(fontSize: 24))),
          ],
        ),
      ),
    );
  }
}
```

---

### 3️⃣ Best Practices
- Use `DefaultTabController` for simple cases.
- Use `TabController` for manual control.
- Use `isScrollable: true` for 5+ tabs.
- Pair with `TabBarView` for content.
- Keep tab labels concise.
- Use icons for better recognition.
- **Recommended:** Use TabBar for 2-5 sections within a screen.

#### Speaker Notes
- TabBar is perfect for organizing content into distinct, switchable sections.

---

## 1️⃣ TabBarView
### Overview
- **Purpose:** Display content corresponding to selected tab.
- **Key Properties:** `children`, `controller`, `physics`.
- **Events:** Page change via controller.
- **Usage Scenarios:** Tab content display, synchronized with TabBar.

#### Speaker Notes
- TabBarView works with TabBar to display corresponding content for each tab.

---

### 2️⃣ Example
```dart
class TabBarViewExample extends StatefulWidget {
  @override
  _TabBarViewExampleState createState() => _TabBarViewExampleState();
}

class _TabBarViewExampleState extends State<TabBarViewExample>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Content Tabs'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Feed'),
            Tab(text: 'Trending'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) => ListTile(
              title: Text('Feed Item $index'),
            ),
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 20,
            itemBuilder: (context, index) => Card(
              child: Center(child: Text('Trending $index')),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, size: 80, color: Colors.red),
                SizedBox(height: 16),
                Text('Your Favorites', style: TextStyle(fontSize: 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
```

---

### 3️⃣ Best Practices
- Always pair with TabBar.
- Use same controller for synchronization.
- Dispose controller properly.
- Use different content types per tab.
- Enable swipe gestures for better UX.

#### Speaker Notes
- TabBarView makes tab-based navigation seamless and intuitive.

---

# 📊 Summary & Key Takeaways

---

## Final Summary
- Flutter provides comprehensive navigation widgets for all app architectures.
- AppBar and Drawer handle app-level structure and secondary navigation.
- BottomNavigationBar (mobile) and NavigationRail (desktop) provide primary navigation.
- PageView enables swipeable page transitions for onboarding and galleries.
- TabBar and TabBarView organize content into sections within screens.

## Key Takeaway
- Choose navigation patterns based on:
  - Number of destinations (3-5 for BottomNavigationBar)
  - Screen size (NavigationRail for wide screens)
  - Navigation depth (Drawer for secondary navigation)
  - Content type (TabBar for sections, PageView for flows)

## Optimization Principles
- Use BottomNavigationBar for 3-5 primary destinations on mobile.
- Use NavigationRail for desktop/tablet layouts.
- Use Drawer for 5+ navigation options.
- Use TabBar for 2-5 sections within a screen.
- Dispose controllers (PageController, TabController) properly.
- Provide clear labels and icons for all navigation elements.
- Test navigation on different screen sizes and orientations.

---

> ![🎯](https://img.icons8.com/color/48/000000/goal.png) **Intuitive navigation is the foundation of excellent user experience!**
