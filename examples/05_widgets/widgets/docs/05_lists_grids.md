# 📋 Lists & Grids

---

## 📋 Lists & Grids

**Widgets for displaying scrollable lists and grids**

> ![📊](https://img.icons8.com/color/48/000000/list.png)

Flutter provides powerful widgets for displaying collections of data in scrollable lists and grids. These widgets are optimized for performance with lazy loading and efficient rendering.

---

# 🧱 Lists

## 1️⃣ ListView
### Overview
- **Purpose:** Scrollable list of widgets arranged linearly.
- **Key Properties:** `children`, `scrollDirection`, `padding`, `physics`, `shrinkWrap`.
- **Events:** Scroll notifications, controller events.
- **Usage Scenarios:** Small, static lists, simple vertical/horizontal scrolling.

#### Speaker Notes
- ListView is ideal for small lists where all items are known upfront and rendered immediately.

---

### 2️⃣ Example
```dart
ListView(
  padding: EdgeInsets.all(16),
  children: [
    Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.music_note, color: Colors.white),
        ),
        title: Text('Song Title 1'),
        subtitle: Text('Artist Name'),
        trailing: Icon(Icons.play_arrow),
      ),
    ),
    Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.music_note, color: Colors.white),
        ),
        title: Text('Song Title 2'),
        subtitle: Text('Artist Name'),
        trailing: Icon(Icons.play_arrow),
      ),
    ),
    Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(Icons.music_note, color: Colors.white),
        ),
        title: Text('Song Title 3'),
        subtitle: Text('Artist Name'),
        trailing: Icon(Icons.play_arrow),
      ),
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use for small lists (< 20 items) with known content.
- Set `shrinkWrap: true` when nested in scrollable widgets.
- Use `physics: NeverScrollableScrollPhysics()` to disable scrolling.
- For large lists, use `ListView.builder` instead.
- Add `padding` for visual spacing.

#### Speaker Notes
- ListView renders all children immediately, so it's best for small, static lists.

---

## 1️⃣ ListView.builder
### Overview
- **Purpose:** Efficient scrollable list with lazy loading for large datasets.
- **Key Properties:** `itemCount`, `itemBuilder`, `scrollDirection`, `padding`, `controller`.
- **Events:** Scroll notifications, item build callbacks.
- **Usage Scenarios:** Large lists, dynamic data, infinite scrolling, performance-critical lists.

#### Speaker Notes
- ListView.builder is the preferred choice for large or dynamic lists due to lazy loading.

---

### 2️⃣ Example
```dart
final List<Map<String, String>> artists = [
  {'name': 'Taylor Swift', 'genre': 'Pop', 'albums': '10'},
  {'name': 'Ed Sheeran', 'genre': 'Pop', 'albums': '5'},
  {'name': 'Adele', 'genre': 'Soul', 'albums': '4'},
  {'name': 'Drake', 'genre': 'Hip Hop', 'albums': '7'},
  {'name': 'Beyoncé', 'genre': 'R&B', 'albums': '8'},
];

ListView.builder(
  itemCount: artists.length,
  padding: EdgeInsets.all(16),
  itemBuilder: (context, index) {
    final artist = artists[index];
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.primaries[index % Colors.primaries.length],
          child: Text(
            artist['name']![0],
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          artist['name']!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text('${artist['genre']} • ${artist['albums']} albums'),
        trailing: IconButton(
          icon: Icon(Icons.favorite_border, color: Colors.red),
          onPressed: () {
            print('Liked ${artist['name']}');
          },
        ),
        onTap: () {
          print('Tapped ${artist['name']}');
        },
      ),
    );
  },
)
```

---

### 3️⃣ Best Practices
- **Always use ListView.builder for lists with 20+ items.**
- Provide accurate `itemCount` to prevent errors.
- Keep `itemBuilder` lightweight for smooth scrolling.
- Use `const` widgets where possible inside `itemBuilder`.
- Implement pull-to-refresh with `RefreshIndicator`.
- Add separators with `ListView.separated`.
- Use `ScrollController` for programmatic scrolling and infinite scroll detection.

#### Speaker Notes
- ListView.builder is the go-to for performance. It only builds visible items, making it efficient for thousands of items.

---

# 🧱 Grids

## 1️⃣ GridView
### Overview
- **Purpose:** Scrollable grid of widgets arranged in rows and columns.
- **Key Properties:** `gridDelegate`, `children`, `scrollDirection`, `padding`.
- **Events:** Scroll notifications.
- **Usage Scenarios:** Small, static grids, photo galleries, product catalogs.

#### Speaker Notes
- GridView displays items in a 2D grid layout, ideal for visual content like images.

---

### 2️⃣ Example
```dart
GridView.count(
  crossAxisCount: 3,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  padding: EdgeInsets.all(16),
  children: [
    Container(
      decoration: BoxDecoration(
        color: Colors.red.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(Icons.image, size: 48, color: Colors.white),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(Icons.video_library, size: 48, color: Colors.white),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(Icons.music_note, size: 48, color: Colors.white),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(Icons.folder, size: 48, color: Colors.white),
      ),
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use `GridView.count` for fixed column count.
- Use `GridView.extent` for fixed item size.
- Set appropriate spacing with `crossAxisSpacing` and `mainAxisSpacing`.
- For large grids, use `GridView.builder`.
- Use `childAspectRatio` to control item proportions.

#### Speaker Notes
- GridView is perfect for galleries and catalogs. Use builder variant for large datasets.

---

## 1️⃣ GridView.builder
### Overview
- **Purpose:** Efficient scrollable grid with lazy loading for large datasets.
- **Key Properties:** `itemCount`, `itemBuilder`, `gridDelegate`, `padding`, `controller`.
- **Events:** Scroll notifications, item build callbacks.
- **Usage Scenarios:** Large grids, dynamic data, image galleries, product listings.

#### Speaker Notes
- GridView.builder provides the same performance benefits as ListView.builder for grid layouts.

---

### 2️⃣ Example
```dart
final List<Map<String, dynamic>> products = List.generate(
  50,
  (index) => {
    'name': 'Product ${index + 1}',
    'price': '\$${(index + 1) * 10}',
    'rating': (4.0 + (index % 10) / 10).toStringAsFixed(1),
    'color': Colors.primaries[index % Colors.primaries.length],
  },
);

GridView.builder(
  padding: EdgeInsets.all(16),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    childAspectRatio: 0.75,
  ),
  itemCount: products.length,
  itemBuilder: (context, index) {
    final product = products[index];
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: product['color'].withOpacity(0.3),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(
                  Icons.shopping_bag,
                  size: 64,
                  color: product['color'],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product['price'],
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(product['rating'], style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
)
```

---

### 3️⃣ Best Practices
- **Always use GridView.builder for grids with 20+ items.**
- Use `SliverGridDelegateWithFixedCrossAxisCount` for fixed columns.
- Use `SliverGridDelegateWithMaxCrossAxisExtent` for responsive grids.
- Keep `itemBuilder` lightweight for smooth scrolling.
- Use `childAspectRatio` to control item height.
- Cache images for better performance in image grids.
- **Recommended:** Use GridView.builder for performance, GridView for small static grids.

#### Speaker Notes
- GridView.builder is essential for large grids. It provides excellent performance with lazy loading.

---

# 🧱 Advanced List Patterns

## 1️⃣ ListView.separated
### Overview
- **Purpose:** List with automatic separators between items.
- **Key Properties:** `itemCount`, `itemBuilder`, `separatorBuilder`.
- **Events:** Scroll notifications.
- **Usage Scenarios:** Lists with dividers, visually separated items.

#### Speaker Notes
- ListView.separated automatically adds separators, keeping code clean and consistent.

---

### 2️⃣ Example
```dart
final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

ListView.separated(
  itemCount: items.length,
  padding: EdgeInsets.symmetric(vertical: 16),
  itemBuilder: (context, index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text('${index + 1}'),
      ),
      title: Text(items[index]),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  },
  separatorBuilder: (context, index) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 72,
      endIndent: 16,
    );
  },
)
```

---

### 3️⃣ Best Practices
- Use for lists that need visual separation.
- Keep `separatorBuilder` simple for performance.
- Customize dividers with indents for alignment.
- Ideal for settings screens and menu lists.

#### Speaker Notes
- ListView.separated keeps separator logic clean and maintainable.

---

## 1️⃣ SliverList & SliverGrid
### Overview
- **Purpose:** Sliver-based lists and grids for advanced scrolling effects.
- **Key Properties:** `delegate`, works within `CustomScrollView`.
- **Events:** Scroll notifications.
- **Usage Scenarios:** Complex scrolling, collapsing headers, mixed content types.

#### Speaker Notes
- Slivers enable advanced scrolling effects like collapsing toolbars and sticky headers.

---

### 2️⃣ Example
```dart
CustomScrollView(
  slivers: [
    SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Artists'),
        background: Image.network(
          'https://picsum.photos/800/400',
          fit: BoxFit.cover,
        ),
      ),
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return ListTile(
            leading: Icon(Icons.person),
            title: Text('Artist ${index + 1}'),
            subtitle: Text('Genre • Albums'),
          );
        },
        childCount: 10,
      ),
    ),
    SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            color: Colors.primaries[index % Colors.primaries.length],
            child: Center(child: Text('${index + 1}')),
          );
        },
        childCount: 12,
      ),
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use within `CustomScrollView` for complex layouts.
- Combine multiple sliver types for rich effects.
- Ideal for collapsing headers and mixed content.
- Use `SliverToBoxAdapter` for single widgets.

#### Speaker Notes
- Slivers unlock advanced scrolling behaviors not possible with standard lists.

---

# 🧱 Pull-to-Refresh & Infinite Scroll

## 1️⃣ RefreshIndicator
### Overview
- **Purpose:** Add pull-to-refresh functionality to scrollable widgets.
- **Key Properties:** `child`, `onRefresh`, `color`, `backgroundColor`.
- **Events:** `onRefresh` callback.
- **Usage Scenarios:** Refreshing data, syncing content, updating lists.

#### Speaker Notes
- RefreshIndicator provides standard pull-to-refresh UX for data updates.

---

### 2️⃣ Example
```dart
RefreshIndicator(
  color: Colors.blue,
  onRefresh: () async {
    // Simulate network request
    await Future.delayed(Duration(seconds: 2));
    // Update data here
    print('Data refreshed');
  },
  child: ListView.builder(
    itemCount: 20,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text('Item $index'),
        subtitle: Text('Pull down to refresh'),
      );
    },
  ),
)
```

---

### 3️⃣ Best Practices
- Wrap any scrollable widget.
- Return a `Future` from `onRefresh`.
- Show loading indicators during refresh.
- Update UI after data loads.

#### Speaker Notes
- RefreshIndicator is expected by users for data-driven lists.

---

## 1️⃣ Infinite Scroll
### Overview
- **Purpose:** Load more data as user scrolls to the end.
- **Key Properties:** `ScrollController` for detection.
- **Events:** Scroll position monitoring.
- **Usage Scenarios:** Paginated data, large datasets, social feeds.

#### Speaker Notes
- Infinite scroll loads data progressively, improving performance and UX.

---

### 2️⃣ Example
```dart
class InfiniteScrollExample extends StatefulWidget {
  @override
  _InfiniteScrollExampleState createState() => _InfiniteScrollExampleState();
}

class _InfiniteScrollExampleState extends State<InfiniteScrollExample> {
  final ScrollController _scrollController = ScrollController();
  List<int> _items = List.generate(20, (index) => index);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == 
        _scrollController.position.maxScrollExtent && !_isLoading) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoading = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _items.addAll(List.generate(20, (index) => _items.length + index));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _items.length + 1,
      itemBuilder: (context, index) {
        if (index == _items.length) {
          return _isLoading 
              ? Center(child: CircularProgressIndicator())
              : SizedBox.shrink();
        }
        return ListTile(title: Text('Item ${_items[index]}'));
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
```

---

### 3️⃣ Best Practices
- Use `ScrollController` to detect scroll end.
- Show loading indicator while fetching.
- Avoid loading duplicate data.
- Dispose controller properly.
- Implement error handling and retry logic.

#### Speaker Notes
- Infinite scroll is essential for modern, data-heavy apps.

---

# 📊 Summary & Key Takeaways

---

## Final Summary
- Flutter provides efficient list and grid widgets for displaying collections.
- ListView.builder and GridView.builder use lazy loading for optimal performance.
- ListView.separated adds automatic separators between items.
- Slivers enable advanced scrolling effects with CustomScrollView.
- RefreshIndicator and infinite scroll enhance data-driven UIs.

## Key Takeaway
- **Always use builder variants for lists/grids with 20+ items.**
- Choose list vs. grid based on content type and layout needs.
- Implement pull-to-refresh and infinite scroll for dynamic data.
- Keep itemBuilder functions lightweight for smooth scrolling.

## Optimization Principles
- Use builder variants for large datasets (20+ items).
- Cache images and heavy computations.
- Use `const` widgets where possible in builders.
- Implement pagination for very large datasets.
- Dispose ScrollControllers to prevent memory leaks.
- Use separators efficiently with ListView.separated.

---

> ![🎯](https://img.icons8.com/color/48/000000/goal.png) **Efficient lists and grids are fundamental to performant Flutter apps!**
