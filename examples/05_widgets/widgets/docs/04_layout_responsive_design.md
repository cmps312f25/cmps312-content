# 📐 Layout & Responsive Design

---

## 📐 Layout & Responsive Design

**Widgets for organizing and adapting UI**

> ![🎨](https://img.icons8.com/color/48/000000/layout.png)

Flutter's layout system provides powerful widgets for structuring and organizing UI elements. These widgets enable responsive designs that adapt seamlessly to different screen sizes and orientations.

---

# 🧱 Page Scaffolding

## 1️⃣ Scaffold
### Overview
- **Purpose:** Implements the basic Material Design visual layout structure.
- **Key Properties:** `appBar`, `body`, `floatingActionButton`, `drawer`, `bottomNavigationBar`, `backgroundColor`.
- **Events:** Drawer and bottom sheet callbacks.
- **Usage Scenarios:** Main app structure, screens with app bar and navigation.

#### Speaker Notes
- Scaffold is the foundation for Material Design screens, providing consistent structure.

---

### 2️⃣ Example
```dart
Scaffold(
  appBar: AppBar(
    title: Text('My App'),
    backgroundColor: Colors.blue,
    actions: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {},
      ),
    ],
  ),
  drawer: Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {},
        ),
      ],
    ),
  ),
  body: Center(child: Text('Welcome!')),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
  bottomNavigationBar: BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ],
  ),
)
```

---

### 3️⃣ Best Practices
- Use Scaffold for all main screens to maintain consistency.
- Combine with AppBar for navigation hierarchy.
- Use drawer for secondary navigation.
- Position FAB appropriately for primary actions.
- Leverage `bottomNavigationBar` for app-level navigation.

#### Speaker Notes
- Scaffold provides a complete Material Design structure out of the box.

---

# 🧱 Flex Layouts

## 1️⃣ Row
### Overview
- **Purpose:** Arrange widgets horizontally in a single line.
- **Key Properties:** `children`, `mainAxisAlignment`, `crossAxisAlignment`, `mainAxisSize`.
- **Events:** None.
- **Usage Scenarios:** Horizontal layouts, toolbars, button groups, form fields.

#### Speaker Notes
- Row is fundamental for horizontal layouts, distributing widgets along the main axis.

---

### 2️⃣ Example
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Icon(Icons.star, color: Colors.amber, size: 32),
    Text('4.5 Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    ElevatedButton(
      onPressed: () {},
      child: Text('View Reviews'),
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use `mainAxisAlignment` to distribute space horizontally.
- Use `crossAxisAlignment` for vertical alignment.
- Wrap with `Expanded` or `Flexible` for responsive children.
- Avoid overflow by constraining child sizes.
- Use `mainAxisSize: MainAxisSize.min` to minimize row width.

#### Speaker Notes
- Row is perfect for horizontal arrangements, but watch for overflow on small screens.

---

## 1️⃣ Column
### Overview
- **Purpose:** Arrange widgets vertically in a single line.
- **Key Properties:** `children`, `mainAxisAlignment`, `crossAxisAlignment`, `mainAxisSize`.
- **Events:** None.
- **Usage Scenarios:** Vertical layouts, forms, lists, content stacking.

#### Speaker Notes
- Column is the vertical counterpart to Row, arranging widgets top to bottom.

---

### 2️⃣ Example
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Product Name', 
         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    SizedBox(height: 8),
    Text('\$49.99', 
         style: TextStyle(fontSize: 20, color: Colors.green)),
    SizedBox(height: 16),
    Row(
      children: [
        Icon(Icons.star, color: Colors.amber),
        Text('4.8 (230 reviews)'),
      ],
    ),
    SizedBox(height: 24),
    ElevatedButton(
      onPressed: () {},
      child: Text('Add to Cart'),
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use `mainAxisAlignment` for vertical spacing.
- Use `crossAxisAlignment` for horizontal alignment.
- Add `SizedBox` for consistent spacing.
- Wrap with `SingleChildScrollView` if content may overflow.
- **Recommended:** Use Column for vertical layouts, Row for horizontal.

#### Speaker Notes
- Column is essential for stacking content vertically. Always plan for scrolling.

---

## 1️⃣ Flex
### Overview
- **Purpose:** Generic flex container (Row and Column extend Flex).
- **Key Properties:** `direction`, `children`, `mainAxisAlignment`, `crossAxisAlignment`.
- **Events:** None.
- **Usage Scenarios:** Dynamic direction layouts, custom flex behaviors.

#### Speaker Notes
- Flex allows dynamic direction switching between horizontal and vertical layouts.

---

### 2️⃣ Example
```dart
bool _isHorizontal = true;

Flex(
  direction: _isHorizontal ? Axis.horizontal : Axis.vertical,
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Container(width: 80, height: 80, color: Colors.red),
    Container(width: 80, height: 80, color: Colors.green),
    Container(width: 80, height: 80, color: Colors.blue),
  ],
)
```

---

### 3️⃣ Best Practices
- Use Row or Column for static direction layouts.
- Use Flex when direction changes dynamically.
- Apply same alignment principles as Row/Column.

#### Speaker Notes
- Flex is powerful for adaptive layouts that change based on orientation or state.

---

# 🧱 Positioning & Layering

## 1️⃣ Stack
### Overview
- **Purpose:** Overlay widgets on top of each other.
- **Key Properties:** `children`, `alignment`, `fit`, `clipBehavior`.
- **Events:** None.
- **Usage Scenarios:** Overlays, badges, background images, floating elements.

#### Speaker Notes
- Stack enables z-axis layering, perfect for overlapping elements.

---

### 2️⃣ Example
```dart
Stack(
  alignment: Alignment.center,
  children: [
    Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.blue],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text('Sale', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    ),
    Icon(Icons.shopping_cart, size: 64, color: Colors.white),
  ],
)
```

---

### 3️⃣ Best Practices
- Use `Positioned` for precise placement.
- Use `alignment` for default positioning.
- Order children from back to front.
- Use `clipBehavior` to handle overflow.
- Ideal for badges, overlays, and custom layouts.

#### Speaker Notes
- Stack is essential for layered designs like badges, floating elements, and overlays.

---

## 1️⃣ Align
### Overview
- **Purpose:** Align a child within its parent.
- **Key Properties:** `alignment`, `child`, `widthFactor`, `heightFactor`.
- **Events:** None.
- **Usage Scenarios:** Precise positioning, centering, corner placement.

#### Speaker Notes
- Align provides precise control over child positioning within a container.

---

### 2️⃣ Example
```dart
Container(
  width: 300,
  height: 200,
  color: Colors.grey.shade200,
  child: Align(
    alignment: Alignment.bottomRight,
    child: Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.add, color: Colors.white),
    ),
  ),
)
```

---

### 3️⃣ Best Practices
- Use for single-child alignment.
- Combine with `FractionalOffset` for precise positioning.
- Use `Center` widget as shorthand for center alignment.
- Prefer `Align` over `Stack` for simple positioning.

#### Speaker Notes
- Align is simpler than Stack for positioning a single child.

---

## 1️⃣ Positioned
### Overview
- **Purpose:** Position a child within a Stack precisely.
- **Key Properties:** `left`, `top`, `right`, `bottom`, `width`, `height`, `child`.
- **Events:** None.
- **Usage Scenarios:** Precise layering, absolute positioning within Stack.

#### Speaker Notes
- Positioned works only within Stack, providing absolute positioning.

---

### 2️⃣ Example
```dart
Stack(
  children: [
    Container(width: 300, height: 300, color: Colors.blue.shade100),
    Positioned(
      left: 20,
      top: 20,
      child: Text('Top Left', style: TextStyle(fontSize: 16)),
    ),
    Positioned(
      right: 20,
      bottom: 20,
      child: ElevatedButton(
        onPressed: () {},
        child: Text('Action'),
      ),
    ),
    Positioned.fill(
      child: Center(
        child: Text('Centered', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use within Stack only.
- Combine `left/right` or `top/bottom` for sizing.
- Use `Positioned.fill` for full-size children.
- Avoid over-positioning; use alignment when possible.

#### Speaker Notes
- Positioned provides pixel-perfect control within stacks.

---

# 🧱 Responsive Design

## 1️⃣ Expanded
### Overview
- **Purpose:** Expand a child to fill available space in flex layouts.
- **Key Properties:** `child`, `flex`.
- **Events:** None.
- **Usage Scenarios:** Filling space in Row/Column, responsive layouts.

#### Speaker Notes
- Expanded distributes available space among flex children proportionally.

---

### 2️⃣ Example
```dart
Row(
  children: [
    Container(
      width: 80,
      height: 60,
      color: Colors.red,
      child: Center(child: Text('Fixed')),
    ),
    Expanded(
      flex: 2,
      child: Container(
        height: 60,
        color: Colors.green,
        child: Center(child: Text('Expanded 2x')),
      ),
    ),
    Expanded(
      flex: 1,
      child: Container(
        height: 60,
        color: Colors.blue,
        child: Center(child: Text('Expanded 1x')),
      ),
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use within Row, Column, or Flex.
- Use `flex` to control proportional sizing.
- Prevents overflow in flexible layouts.
- **Recommended:** Use Expanded for filling space, Flexible for optional expansion.

#### Speaker Notes
- Expanded is crucial for responsive layouts that adapt to screen sizes.

---

## 1️⃣ Flexible
### Overview
- **Purpose:** Allow a child to flex but not force it to fill space.
- **Key Properties:** `child`, `flex`, `fit`.
- **Events:** None.
- **Usage Scenarios:** Optional expansion, content-sized flexibility.

#### Speaker Notes
- Flexible allows widgets to shrink or grow without forcing full expansion.

---

### 2️⃣ Example
```dart
Row(
  children: [
    Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: Container(
        height: 60,
        color: Colors.orange,
        child: Center(child: Text('Flexible')),
      ),
    ),
    Container(
      width: 100,
      height: 60,
      color: Colors.purple,
      child: Center(child: Text('Fixed')),
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use `FlexFit.tight` for Expanded behavior.
- Use `FlexFit.loose` for content-based sizing.
- Prefer Expanded when widget must fill space.
- Use Flexible for optional growth.

#### Speaker Notes
- Flexible provides more control than Expanded for adaptive sizing.

---

## 1️⃣ LayoutBuilder
### Overview
- **Purpose:** Build widgets based on parent constraints.
- **Key Properties:** `builder` (receives constraints).
- **Events:** None.
- **Usage Scenarios:** Responsive UIs, adaptive layouts, constraint-based rendering.

#### Speaker Notes
- LayoutBuilder enables truly responsive designs that react to available space.

---

### 2️⃣ Example
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      // Wide layout (tablet/desktop)
      return Row(
        children: [
          Expanded(
            child: Container(color: Colors.blue, height: 200),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Container(color: Colors.green, height: 200),
          ),
        ],
      );
    } else {
      // Narrow layout (mobile)
      return Column(
        children: [
          Container(color: Colors.blue, height: 200),
          SizedBox(height: 16),
          Container(color: Colors.green, height: 200),
        ],
      );
    }
  },
)
```

---

### 3️⃣ Best Practices
- Use for responsive, constraint-based layouts.
- Switch between layouts based on width/height.
- Combine with MediaQuery for comprehensive responsiveness.
- Ideal for adaptive dashboards and multi-column layouts.

#### Speaker Notes
- LayoutBuilder is essential for creating truly adaptive UIs.

---

# 🧱 Safe Zones & Constraints

## 1️⃣ SafeArea
### Overview
- **Purpose:** Inset child to avoid system UI intrusions.
- **Key Properties:** `child`, `top`, `bottom`, `left`, `right`, `minimum`.
- **Events:** None.
- **Usage Scenarios:** Avoid notches, status bars, navigation bars.

#### Speaker Notes
- SafeArea ensures content doesn't get hidden by system UI elements.

---

### 2️⃣ Example
```dart
Scaffold(
  body: SafeArea(
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.blue,
          child: Text('This content respects safe areas', 
                      style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        Expanded(
          child: Center(child: Text('Main Content')),
        ),
      ],
    ),
  ),
)
```

---

### 3️⃣ Best Practices
- Wrap body content in SafeArea.
- Disable specific sides if needed (e.g., `top: false`).
- Essential for devices with notches or rounded corners.
- Combine with Scaffold for complete layouts.

#### Speaker Notes
- Always use SafeArea to ensure content visibility on all devices.

---

## 1️⃣ MediaQuery
### Overview
- **Purpose:** Access screen size, orientation, and device information.
- **Key Properties:** `size`, `orientation`, `padding`, `viewInsets`, `devicePixelRatio`.
- **Events:** None.
- **Usage Scenarios:** Responsive sizing, orientation handling, keyboard detection.

#### Speaker Notes
- MediaQuery provides critical device information for responsive design.

---

### 2️⃣ Example
```dart
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final orientation = MediaQuery.of(context).orientation;
  final isLandscape = orientation == Orientation.landscape;
  
  return Container(
    width: size.width * 0.9, // 90% of screen width
    height: isLandscape ? size.height * 0.5 : size.height * 0.3,
    color: Colors.blue,
    child: Center(
      child: Text(
        'Screen: ${size.width.toInt()}x${size.height.toInt()}',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
  );
}
```

---

### 3️⃣ Best Practices
- Use for responsive sizing calculations.
- Check orientation for layout decisions.
- Access `padding` for safe area insets.
- Use `viewInsets` to detect keyboard visibility.
- Combine with LayoutBuilder for complete responsiveness.

#### Speaker Notes
- MediaQuery is fundamental for creating adaptive, device-aware UIs.

---

# 📊 Summary & Key Takeaways

---

## Final Summary
- Scaffold provides the foundation for Material Design screens.
- Row and Column are essential for linear layouts.
- Stack enables layering and overlapping elements.
- Expanded and Flexible create responsive flex layouts.
- LayoutBuilder and MediaQuery enable truly adaptive UIs.
- SafeArea ensures content visibility on all devices.

## Key Takeaway
- Combine layout widgets to create complex, responsive UIs.
- Use Scaffold for consistent screen structure.
- Plan for different screen sizes and orientations from the start.
- Use appropriate spacing and alignment for professional results.

## Optimization Principles
- Minimize widget nesting for better performance.
- Use Expanded/Flexible instead of fixed sizes when possible.
- Combine LayoutBuilder and MediaQuery for comprehensive responsiveness.
- Always use SafeArea to respect device boundaries.
- Test layouts on multiple screen sizes and orientations.

---

> ![🎯](https://img.icons8.com/color/48/000000/goal.png) **Mastering layout widgets is key to creating beautiful, responsive Flutter UIs!**
