# 🎯 Interaction & Action Controls

---

## 🎯 Interaction & Action Controls

**Widgets for user actions and gestures**

> ![👆](https://img.icons8.com/color/48/000000/touch.png)

Flutter provides powerful widgets for handling user interactions, from simple button taps to complex gesture recognition. These widgets enable users to interact with your app through intuitive actions and responsive feedback.

---

# 🧱 Buttons & Action Triggers

## 1️⃣ ElevatedButton
### Overview
- **Purpose:** Primary action button with elevation and shadow.
- **Key Properties:** `onPressed`, `child`, `style`, `icon`, `autofocus`.
- **Events:** `onPressed`, `onLongPress`, `onHover`, `onFocusChange`.
- **Usage Scenarios:** Primary actions, form submissions, call-to-action.

#### Speaker Notes
- ElevatedButton is the most prominent button type, ideal for primary actions that need emphasis.

---

### 2️⃣ Example
```dart
ElevatedButton(
  onPressed: () {
    print('Submit pressed');
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: Text('Submit', style: TextStyle(fontSize: 16)),
)
```

---

### 3️⃣ Best Practices
- Use for primary, high-emphasis actions.
- Disable with `onPressed: null` to show inactive state.
- Provide visual feedback with hover and focus states.
- Avoid using multiple elevated buttons on the same screen.

#### Speaker Notes
- The elevation makes the button stand out. Use sparingly for primary actions only.

---

## 1️⃣ TextButton
### Overview
- **Purpose:** Low-emphasis button without elevation.
- **Key Properties:** `onPressed`, `child`, `style`, `icon`.
- **Events:** `onPressed`, `onLongPress`.
- **Usage Scenarios:** Secondary actions, dialogs, toolbars, inline actions.

#### Speaker Notes
- TextButton is ideal for less important actions that don't need visual prominence.

---

### 2️⃣ Example
```dart
TextButton(
  onPressed: () {
    Navigator.pop(context);
  },
  style: TextButton.styleFrom(
    foregroundColor: Colors.blue,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  ),
  child: Text('Cancel', style: TextStyle(fontSize: 14)),
)
```

---

### 3️⃣ Best Practices
- Use for secondary or cancel actions.
- Pair with ElevatedButton for clear action hierarchy.
- Ideal for dialog buttons and inline links.
- Keep text concise and action-oriented.

#### Speaker Notes
- TextButton provides a clean, minimal look perfect for secondary actions.

---

## 1️⃣ OutlinedButton
### Overview
- **Purpose:** Medium-emphasis button with border outline.
- **Key Properties:** `onPressed`, `child`, `style`, `icon`.
- **Events:** `onPressed`, `onLongPress`.
- **Usage Scenarios:** Secondary actions, alternative options, card actions.

#### Speaker Notes
- OutlinedButton sits between ElevatedButton and TextButton in visual hierarchy.

---

### 2️⃣ Example
```dart
OutlinedButton(
  onPressed: () {
    print('View Details');
  },
  style: OutlinedButton.styleFrom(
    foregroundColor: Colors.deepPurple,
    side: BorderSide(color: Colors.deepPurple, width: 2),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: Text('View Details'),
)
```

---

### 3️⃣ Best Practices
- Use for secondary actions that need more emphasis than TextButton.
- Maintain consistent border styling across the app.
- Ideal for alternative actions or "Learn More" buttons.
- Customize border color to match theme.

#### Speaker Notes
- OutlinedButton provides a good middle ground for secondary actions.

---

## 1️⃣ IconButton
### Overview
- **Purpose:** Compact button displaying an icon.
- **Key Properties:** `icon`, `onPressed`, `iconSize`, `color`, `tooltip`.
- **Events:** `onPressed`.
- **Usage Scenarios:** Toolbars, app bars, compact actions, toggles.

#### Speaker Notes
- IconButton is perfect for compact UI elements where space is limited.

---

### 2️⃣ Example
```dart
IconButton(
  icon: Icon(Icons.favorite),
  iconSize: 28,
  color: Colors.red,
  tooltip: 'Add to Favorites',
  onPressed: () {
    print('Added to favorites');
  },
)
```

---

### 3️⃣ Best Practices
- Always provide a tooltip for accessibility.
- Use consistent icon sizes across the app.
- Ideal for toolbars, app bars, and navigation.
- Ensure adequate touch target size (48x48 minimum).

#### Speaker Notes
- IconButton saves space while providing clear actions. Always use tooltips.

---

## 1️⃣ FloatingActionButton
### Overview
- **Purpose:** Prominent circular button for primary screen action.
- **Key Properties:** `onPressed`, `child`, `backgroundColor`, `elevation`, `mini`.
- **Events:** `onPressed`.
- **Usage Scenarios:** Primary screen action (add, compose, create).

#### Speaker Notes
- FAB represents the most important action on a screen, typically floating above content.

---

### 2️⃣ Example
```dart
FloatingActionButton(
  onPressed: () {
    print('Create new item');
  },
  backgroundColor: Colors.blue,
  elevation: 6,
  child: Icon(Icons.add, color: Colors.white),
  tooltip: 'Create New',
)
```

---

### 3️⃣ Best Practices
- Use one FAB per screen for the primary action.
- Position at bottom-right (default) or bottom-center.
- Use `mini: true` for secondary FABs.
- Provide clear icon representing the action.

#### Speaker Notes
- FAB should represent the most natural, frequent action on the screen.

---

# 🧱 Gestures & Touch Interactions

## 1️⃣ GestureDetector
### Overview
- **Purpose:** Detect and respond to various gestures without visual feedback.
- **Key Properties:** `child`, `onTap`, `onDoubleTap`, `onLongPress`, `onPanUpdate`, `onScaleUpdate`.
- **Events:** Tap, double-tap, long press, drag, scale, and more.
- **Usage Scenarios:** Custom interactions, drag-and-drop, swipe actions.

#### Speaker Notes
- GestureDetector provides low-level gesture recognition without Material ripple effects.

---

### 2️⃣ Example
```dart
GestureDetector(
  onTap: () {
    print('Tapped');
  },
  onDoubleTap: () {
    print('Double tapped');
  },
  onLongPress: () {
    print('Long pressed');
  },
  onPanUpdate: (details) {
    print('Dragging: ${details.delta}');
  },
  child: Container(
    width: 200,
    height: 200,
    color: Colors.blue.shade100,
    child: Center(
      child: Text('Tap, Double Tap, or Long Press'),
    ),
  ),
)
```

---

### 3️⃣ Best Practices
- Use for custom gesture handling without Material effects.
- Provide visual feedback manually if needed.
- Combine multiple gestures carefully to avoid conflicts.
- Use for non-button widgets that need interaction.

#### Speaker Notes
- GestureDetector is powerful but requires manual feedback implementation.

---

## 1️⃣ InkWell
### Overview
- **Purpose:** Detect taps with Material Design ripple effect.
- **Key Properties:** `child`, `onTap`, `onLongPress`, `borderRadius`, `splashColor`.
- **Events:** `onTap`, `onDoubleTap`, `onLongPress`, `onHover`.
- **Usage Scenarios:** Card taps, list item actions, custom tappable widgets.

#### Speaker Notes
- InkWell provides Material ripple effects, enhancing user feedback and polish.

---

### 2️⃣ Example
```dart
InkWell(
  onTap: () {
    print('Card tapped');
  },
  borderRadius: BorderRadius.circular(12),
  splashColor: Colors.blue.withOpacity(0.3),
  child: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(Icons.music_note, size: 40, color: Colors.purple),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Song Title', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Artist Name', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    ),
  ),
)
```

---

### 3️⃣ Best Practices
- Prefer InkWell over GestureDetector for Material Design apps.
- Use `borderRadius` to match container shape.
- Customize `splashColor` and `highlightColor` for branding.
- Wrap with `Ink` widget for colored backgrounds.

#### Speaker Notes
- InkWell provides professional touch feedback. Use it for all tappable Material widgets.

---

# 📊 Summary & Key Takeaways

---

## Final Summary
- Flutter offers a complete suite of interaction widgets for various action types.
- Button hierarchy: ElevatedButton (primary) → OutlinedButton (secondary) → TextButton (tertiary).
- GestureDetector for custom gestures, InkWell for Material Design feedback.

## Key Takeaway
- Choose button types based on action importance and visual hierarchy.
- Always provide feedback for user actions (visual, haptic, or both).
- Use appropriate gesture widgets based on Material Design requirements.

## Optimization Principles
- Maintain consistent button styling across the app.
- Ensure adequate touch target sizes (minimum 48x48).
- Provide tooltips and accessibility labels.
- Use InkWell for polished Material interactions.

---

> ![🎯](https://img.icons8.com/color/48/000000/goal.png) **Well-designed interaction controls make apps intuitive and delightful to use!**
