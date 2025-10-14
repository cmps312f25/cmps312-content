# 🪶 Content & Presentation Widgets

---

## 🪶 Content & Presentation Widgets

**Widgets for displaying text, media, and structured information**

> ![🖼️](https://img.icons8.com/color/48/000000/presentation.png)

Flutter provides a rich set of widgets for presenting content, including text, images, icons, and structured layouts. These widgets form the foundation for building visually engaging and informative UIs.

---

# 🧱 Text & Typography

## 1️⃣ Text
### Overview
- **Purpose:** Display simple text with single style.
- **Key Properties:** `data`, `style`, `textAlign`, `overflow`, `maxLines`.
- **Events:** None (static display).
- **Usage Scenarios:** Labels, headings, paragraphs.

#### Speaker Notes
- Use `Text` for most static text needs. Style with `TextStyle` for color, font, and weight.

---

### 2️⃣ Example
```dart
Text(
  'Welcome to Flutter!',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blueAccent,
  ),
  textAlign: TextAlign.center,
)
```

---

### 3️⃣ Best Practices
- Prefer `Text` for simple, single-style text.
- Use `style` for consistent typography.
- Avoid nesting multiple `Text` widgets for formatting; use `RichText` instead.

#### Speaker Notes
- Keep text concise and readable. Use semantic font sizes and weights.

---

## 1️⃣ RichText
### Overview
- **Purpose:** Display text with multiple styles and spans.
- **Key Properties:** `text` (TextSpan), `textAlign`, `overflow`.
- **Events:** None.
- **Usage Scenarios:** Highlighted text, mixed styles, inline links.

#### Speaker Notes
- Use `RichText` for advanced formatting, such as colored or clickable spans.

---

### 2️⃣ Example
```dart
RichText(
  text: TextSpan(
    children: [
      TextSpan(text: 'Flutter ', style: TextStyle(color: Colors.blue, fontSize: 20)),
      TextSpan(text: 'is ', style: TextStyle(color: Colors.black, fontSize: 20)),
      TextSpan(text: 'awesome!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20)),
    ],
  ),
)
```

---

### 3️⃣ Best Practices
- Use `TextSpan` for inline styling and links.
- Avoid excessive nesting for performance.
- Use `GestureRecognizer` for interactive spans.

#### Speaker Notes
- Great for highlighting keywords or creating inline links.

---

## 1️⃣ SelectableText
### Overview
- **Purpose:** Display text that users can select and copy.
- **Key Properties:** `data`, `style`, `onTap`, `toolbarOptions`.
- **Events:** `onSelectionChanged`, `onTap`.
- **Usage Scenarios:** Code samples, addresses, emails.

#### Speaker Notes
- Use for content that users may need to copy, such as code or contact info.

---

### 2️⃣ Example
```dart
SelectableText(
  'Copy this email: info@flutter.dev',
  style: TextStyle(fontSize: 18, color: Colors.deepPurple),
)
```

---

### 3️⃣ Best Practices
- Use for user-facing, copyable content.
- Customize toolbar for common actions.
- Avoid for sensitive info.

#### Speaker Notes
- Improves UX for documentation and contact details.

---

# 🧱 Media & Graphics

## 1️⃣ Image
### Overview
- **Purpose:** Display images from assets, network, or file.
- **Key Properties:** `image`, `fit`, `width`, `height`, `colorBlendMode`.
- **Events:** `loadingBuilder`, `errorBuilder`.
- **Usage Scenarios:** Product images, avatars, banners.

#### Speaker Notes
- Use asset images for local resources, network for remote.

---

### 2️⃣ Example
```dart
Image.asset(
  'assets/images/logo.png',
  width: 120,
  height: 120,
  fit: BoxFit.cover,
)
```

---

### 3️⃣ Best Practices
- Use `BoxFit` for scaling.
- Optimize image sizes for performance.
- Handle errors gracefully.

#### Speaker Notes
- Preload images for smoother UX. Use placeholders for slow networks.

---

## 1️⃣ Icon
### Overview
- **Purpose:** Display vector icons from Material or custom sets.
- **Key Properties:** `icon`, `size`, `color`, `semanticLabel`.
- **Events:** None.
- **Usage Scenarios:** Buttons, status indicators, navigation.

#### Speaker Notes
- Use icons for quick visual cues and actions.

---

### 2️⃣ Example
```dart
Icon(
  Icons.star,
  color: Colors.amber,
  size: 32,
)
```

---

### 3️⃣ Best Practices
- Use semantic labels for accessibility.
- Keep icon sizes consistent.
- Prefer Material icons for standard UI.

#### Speaker Notes
- Icons enhance clarity and reduce text clutter.

---

# 🧱 Structured Display

## 1️⃣ Card
### Overview
- **Purpose:** Display content in a visually distinct container.
- **Key Properties:** `child`, `elevation`, `shape`, `color`, `margin`.
- **Events:** None.
- **Usage Scenarios:** Product cards, profile cards, dashboards.

#### Speaker Notes
- Use cards to group related content and add depth.

---

### 2️⃣ Example
```dart
Card(
  elevation: 4,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Artist Profile'),
  ),
)
```

---

### 3️⃣ Best Practices
- Use elevation for visual hierarchy.
- Group related info in cards.
- Avoid excessive nesting.

#### Speaker Notes
- Cards improve scanability and structure.

---

## 1️⃣ ListTile
### Overview
- **Purpose:** Display structured rows with leading/trailing widgets.
- **Key Properties:** `leading`, `title`, `subtitle`, `trailing`, `onTap`.
- **Events:** `onTap`, `onLongPress`.
- **Usage Scenarios:** Settings, lists, menus.

#### Speaker Notes
- Use for list items with icons, text, and actions.

---

### 2️⃣ Example
```dart
ListTile(
  leading: Icon(Icons.person),
  title: Text('John Doe'),
  subtitle: Text('Artist'),
  trailing: Icon(Icons.arrow_forward_ios),
  onTap: () {},
)
```

---

### 3️⃣ Best Practices
- Use consistent spacing and icons.
- Avoid overcrowding tiles.
- Use trailing for actions.

#### Speaker Notes
- ListTiles are ideal for navigation and settings.

---

## 1️⃣ Table
### Overview
- **Purpose:** Display tabular data in rows and columns.
- **Key Properties:** `children`, `border`, `columnWidths`.
- **Events:** None.
- **Usage Scenarios:** Schedules, pricing tables.

#### Speaker Notes
- Use for static, small tables. For large data, use `DataTable`.

---

### 2️⃣ Example
```dart
Table(
  border: TableBorder.all(),
  children: [
    TableRow(children: [Text('Name'), Text('Role')]),
    TableRow(children: [Text('Alice'), Text('Designer')]),
    TableRow(children: [Text('Bob'), Text('Developer')]),
  ],
)
```

---

### 3️⃣ Best Practices
- Use for simple, static data.
- Avoid for dynamic or large datasets.
- Style with borders and padding.

#### Speaker Notes
- Tables are best for small, static data sets.

---

## 1️⃣ DataTable
### Overview
- **Purpose:** Display interactive, sortable tabular data.
- **Key Properties:** `columns`, `rows`, `sortColumnIndex`, `onSort`.
- **Events:** `onSelectChanged`, `onSort`.
- **Usage Scenarios:** Admin panels, reports, data grids.

#### Speaker Notes
- Use for large, interactive tables with sorting and selection.

---

### 2️⃣ Example
```dart
DataTable(
  columns: [
    DataColumn(label: Text('Name')),
    DataColumn(label: Text('Score'), numeric: true),
  ],
  rows: [
    DataRow(cells: [DataCell(Text('Alice')), DataCell(Text('95'))]),
    DataRow(cells: [DataCell(Text('Bob')), DataCell(Text('88'))]),
  ],
)
```

---

### 3️⃣ Best Practices
- Use for interactive, sortable data.
- Optimize for performance with large datasets.
- Use `DataColumn` and `DataRow` for structure.

#### Speaker Notes
- DataTable is ideal for dashboards and admin panels.

---

# 📊 Summary & Key Takeaways

---

## Final Summary
- Content & Presentation widgets are the backbone of Flutter UIs.
- Use appropriate widgets for text, media, and structured data.
- Combine widgets for rich, engaging interfaces.

## Key Takeaway
- Choose the simplest widget for the job.
- Optimize for readability and performance.
- Use consistent styling and structure.

## Optimization Principles
- Preload images and assets.
- Minimize widget nesting.
- Use semantic widgets for accessibility.

---

> ![🎯](https://img.icons8.com/color/48/000000/goal.png) **Mastering content & presentation widgets unlocks the full potential of Flutter UI design!**
