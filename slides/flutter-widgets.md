# Essential Flutter Widgets Reference Guide

This document organizes the most crucial Flutter widgets by functional category, includes practical examples, usage scenarios, comparisons, and clear design guidelines. All code blocks use fenced Dart notation for easy copying.

***

## Data Display \& Visualization Widgets

### Text

**Purpose:** Displays string text with rich formatting and style options.
[Text API Docs](https://api.flutter.dev/flutter/widgets/Text-class.html)

- **Key Properties:**
    - `style` – Controls font, size, color, weight, etc.
    - `maxLines` – Maximum number of lines
    - `overflow` – What happens with excess text
- **Code Example:**

```dart
Text(
  'Welcome to Flutter!',
  style: TextStyle(fontSize: 20, color: Colors.blue),
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

- **Scenarios:** Titles, labels, button text

***

### RichText

**Purpose:** Styled text using multiple TextStyles in a single widget.
[RichText API Docs](https://api.flutter.dev/flutter/widgets/RichText-class.html)

- **Key Properties:**
    - `text` – Tree of TextSpans
    - `textAlign`, `overflow`
- **Code Example:**

```dart
RichText(
  text: TextSpan(
    children: [
      TextSpan(text: 'Hello ', style: TextStyle(color: Colors.black)),
      TextSpan(text: 'Flutter', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
    ],
  ),
)
```

- **Scenarios:** Mixed formatting, links in text

***

### Image

**Purpose:** Shows image from asset, network, or file source.
[Image API Docs](https://api.flutter.dev/flutter/widgets/Image-class.html)

- **Key Properties:**
    - `image` – Source
    - `fit`, `width`, `height`
- **Code Example:**

```dart
Image.network(
  'https://flutter.dev/images/flutter-logo-sharing.png',
  width: 120,
  height: 80,
  fit: BoxFit.contain,
)
```

- **Scenarios:** Avatars, product images, galleries

***

### Icon

**Purpose:** Displays vector icon.
[Icon API Docs](https://api.flutter.dev/flutter/widgets/Icon-class.html)

- **Key Properties:**
    - `icon` – IconData
    - `size`, `color`
- **Code Example:**

```dart
Icon(Icons.home, size: 48, color: Colors.green)
```


***

### Card

**Purpose:** Material container for grouping, with elevation.
[Card API Docs](https://api.flutter.dev/flutter/material/Card-class.html)

- **Key Properties:**
    - `elevation`, `margin`, `child`
- **Code Example:**

```dart
Card(
  elevation: 3,
  margin: EdgeInsets.all(12),
  child: ListTile(title: Text('Flutter Card')),
)
```


***

### ListView

**Purpose:** Scrollable list of widgets.
[ListView API Docs](https://api.flutter.dev/flutter/widgets/ListView-class.html)

- **Key Properties:**
    - `children`
    - `scrollDirection`
    - `itemBuilder`
- **Code Example:**

```dart
ListView(
  children: [Text('Item 1'), Text('Item 2'), Icon(Icons.check)],
)
```


***

### ExpansionTile

**Purpose:** Expand/collapse list for hierarchical or detailed data.
[ExpansionTile API Docs](https://api.flutter.dev/flutter/material/ExpansionTile-class.html)

- **Key Properties:**
    - `title`, `children`, `leading`, `trailing`
- **Code Example:**

```dart
ExpansionTile(
  title: Text('Account Settings'),
  leading: Icon(Icons.account_circle),
  children: [
    ListTile(title: Text('Profile'), onTap: () {}),
    ListTile(title: Text('Privacy'), onTap: () {}),
    ListTile(title: Text('Security'), onTap: () {}),
  ],
)
```


***

## Interaction \& Button Widgets

### ElevatedButton

**Purpose:** Raised button for main actions.
[ElevatedButton API Docs](https://api.flutter.dev/flutter/material/ElevatedButton-class.html)

- **Key Properties:**
    - `onPressed`, `style`, `child`
- **Code Example:**

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
  child: Text('Submit'),
)
```


***

### TextButton

**Purpose:** Flat secondary action button.
[TextButton API Docs](https://api.flutter.dev/flutter/material/TextButton-class.html)

- **Key Properties:**
    - `onPressed`, `child`, `style`
- **Code Example:**

```dart
TextButton(
  onPressed: () {},
  style: TextButton.styleFrom(primary: Colors.red),
  child: Text('Cancel'),
)
```


***

### OutlinedButton

**Purpose:** Border-outlined secondary option.
[OutlinedButton API Docs](https://api.flutter.dev/flutter/material/OutlinedButton-class.html)

- **Key Properties:**
    - `onPressed`, `child`, `style`

***

### IconButton

**Purpose:** Compact, tappable icon button.
[IconButton API Docs](https://api.flutter.dev/flutter/material/IconButton-class.html)

- **Key Properties:**
    - `onPressed`, `icon`, `tooltip`

***

### FloatingActionButton

**Purpose:** Circular, primary action button.
[FloatingActionButton API Docs](https://api.flutter.dev/flutter/material/FloatingActionButton-class.html)

- **Key Properties:**
    - `onPressed`, `child`, `backgroundColor`

***

### InkWell \& GestureDetector

**Purpose:** Touch event detection, ripple feedback.
[GestureDetector API Docs](https://api.flutter.dev/flutter/widgets/GestureDetector-class.html)
[InkWell API Docs](https://api.flutter.dev/flutter/material/InkWell-class.html)

***

## Selection Widgets

### Checkbox

**Purpose:** Multi-select independent options.
[Checkbox API Docs](https://api.flutter.dev/flutter/material/Checkbox-class.html)

- **Key Properties:** `value`, `onChanged`, `tristate`
- **Usage Scenarios:** Preferences, todo lists


### CheckboxListTile

**Purpose:** Checkbox with label and description.
[CheckboxListTile API Docs](https://api.flutter.dev/flutter/material/CheckboxListTile-class.html)

- **Key Properties:** `title`, `subtitle`, `secondary`, `controlAffinity`


### Radio \& RadioListTile

**Purpose:** Single choice among mutually exclusive options.
[Radio API Docs](https://api.flutter.dev/flutter/material/Radio-class.html)
[RadioListTile API Docs](https://api.flutter.dev/flutter/material/RadioListTile-class.html)

### Switch \& SwitchListTile

**Purpose:** Binary on/off toggle.
[Switch API Docs](https://api.flutter.dev/flutter/material/Switch-class.html)

- **Key Properties:** `value`, `onChanged`, `activeColor`


### DropdownButton \& DropdownButtonFormField

**Purpose:** Compact, single selection for large option sets.
[DropdownButton API Docs](https://api.flutter.dev/flutter/material/DropdownButton-class.html)

- **Key Properties:** `value`, `items`, `onChanged`, `hint`
- **Usage Scenarios:** Country, category, language, sort, etc.


### Chip, FilterChip, ChoiceChip

**Purpose:** Tag, filter, attribute, or category selection.
[Chip API Docs](https://api.flutter.dev/flutter/material/Chip-class.html)

- **Key Properties:** `label`, `avatar`, `onDeleted`, `selected`, `onSelected`


### PopupMenuButton

**Purpose:** Overflow, context menu actions.
[PopupMenuButton API Docs](https://api.flutter.dev/flutter/material/PopupMenuButton-class.html)

### Slider \& RangeSlider

**Purpose:** Choose numeric values/ranges.
[Slider API Docs](https://api.flutter.dev/flutter/material/Slider-class.html)

### Date \& Time Pickers

For date/time selection:
[showDatePicker API Docs](https://api.flutter.dev/flutter/material/showDatePicker.html)
[showTimePicker API Docs](https://api.flutter.dev/flutter/material/showTimePicker.html)

***

### Selection Widget Comparison \& Guidelines

| Widget | Multi-Select | Single Select | Suited For | Typical Scenario |
| :-- | :-- | :-- | :-- | :-- |
| Checkbox | ✅ |  | Booleans, many options | Preferences, lists, toggles |
| Radio |  | ✅ | 2–7 visible choices | Gender, payment, format, category |
| Switch |  | ✅ | Binary toggle | Enable/disable, config, features |
| Dropdown |  | ✅ | Long lists, space constrained | Country, category, filter, language |
| Chip (Filter) | ✅ |  | Visual filters/tags | Multi-category filter, tags |
| ChoiceChip |  | ✅ | Short, visual options | Size, color, theme, mode |
| PopupMenu | ✅ / ✅ | ✅ / ✅ | Secondary/contextual | List item actions, toolbars, overflow |
| Slider |  | ✅ | Numeric continuous | Volume, rating, price, time |

**Design Guidance:**

- Use Checkbox for multi-select, Radio for single mutually exclusive choice, and Switch for binary enable/disable states.
- Use Dropdown for lengthy option lists; Chips for visual grouping and selection of tags/categories.
- Use RadioListTile, CheckboxListTile, SwitchListTile for settings or option lists needing descriptions.
- PopupMenuButton for overflow/context menus to keep screens clutter-free.

***

## Navigation \& Routing Widgets

AppBar, Drawer, BottomNavigationBar, BottomAppBar, TabBar, TabBarView, Navigator, etc.

***

## Theming \& Styling Widgets

Theme, ThemeData, Material, Container, Padding, Align, etc.

**ThemeData Usage:**
Set app theme in `MaterialApp` and override with `.copyWith` or `Theme.of(context).copyWith()`.
Example:

```dart
MaterialApp(
  theme: ThemeData.light().copyWith(
    primaryColor: Colors.purple,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
    ),
  ),
)
```


***

## Animation Widgets

AnimatedContainer, Hero, AnimatedOpacity, FadeTransition, AnimatedBuilder, etc.

***

## Miscellaneous Widgets

Scaffold, SafeArea, CircularProgressIndicator, LinearProgressIndicator, Divider, Tooltip, etc.

***

## References

- See official docs for each widget at [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets).
- Copy and use markdown sections directly for technical documentation, Word, or PowerPoint slides.

***

**Export Instructions:**

- Open this markdown file in Word or PowerPoint (via paste).
- For Word: Use headings and code blocks for sections.
- For PowerPoint: Copy key lists and examples to slides.
- All fenced Dart code is formatted for immediate copy-paste into Flutter apps or developer docs.

---
