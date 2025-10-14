# 🪟 Overlays & Floating Surfaces

---

## 🪟 Overlays & Floating Surfaces

**Widgets for temporary UI layers**

> ![💬](https://img.icons8.com/color/48/000000/popup.png)

Flutter provides powerful widgets for displaying temporary content above the main UI. These overlay widgets include dialogs, bottom sheets, and popup menus that enhance user interaction without navigating away.

---

# 🧱 Dialogs & Alerts

## 1️⃣ AlertDialog
### Overview
- **Purpose:** Display important messages requiring user acknowledgment or decision.
- **Key Properties:** `title`, `content`, `actions`, `backgroundColor`, `shape`, `elevation`.
- **Events:** Action button callbacks.
- **Usage Scenarios:** Confirmations, warnings, errors, important messages.

#### Speaker Notes
- AlertDialog interrupts the user flow to present critical information or choices.

---

### 2️⃣ Example
```dart
ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Confirm Delete'),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this item? This action cannot be undone.',
            style: TextStyle(fontSize: 16),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                print('Item deleted');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  },
  child: Text('Show Alert Dialog'),
)
```

---

### 3️⃣ Best Practices
- Use for critical decisions and confirmations.
- Provide clear, concise title and content.
- Offer 1-3 action buttons (2 is ideal).
- Use `barrierDismissible: false` for critical dialogs.
- Place primary action on the right.
- Use color coding for destructive actions (red).
- Keep content brief and scannable.

#### Speaker Notes
- AlertDialog should interrupt flow only for important decisions. Make actions clear and consequences obvious.

---

## 1️⃣ SimpleDialog
### Overview
- **Purpose:** Present a list of options for user selection.
- **Key Properties:** `title`, `children` (SimpleDialogOption), `backgroundColor`, `shape`.
- **Events:** Option selection callbacks.
- **Usage Scenarios:** Choice selection, option lists, simple menus.

#### Speaker Notes
- SimpleDialog presents multiple options in a clean, organized format.

---

### 2️⃣ Example
```dart
ElevatedButton(
  onPressed: () async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Music Genre'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Pop');
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.music_note, color: Colors.purple),
                    SizedBox(width: 16),
                    Text('Pop', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Rock');
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.album, color: Colors.red),
                    SizedBox(width: 16),
                    Text('Rock', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Jazz');
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.piano, color: Colors.blue),
                    SizedBox(width: 16),
                    Text('Jazz', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Classical');
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.library_music, color: Colors.green),
                    SizedBox(width: 16),
                    Text('Classical', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
    if (result != null) {
      print('Selected: $result');
    }
  },
  child: Text('Show Simple Dialog'),
)
```

---

### 3️⃣ Best Practices
- Use for selecting from a list of options.
- Keep options concise and clear.
- Use icons for visual recognition.
- Limit to 4-6 options for usability.
- Return selected value with `Navigator.pop()`.
- For many options, use bottom sheet or full screen.

#### Speaker Notes
- SimpleDialog is perfect for quick option selection without navigating away.

---

# 🧱 Bottom Sheets

## 1️⃣ BottomSheet
### Overview
- **Purpose:** Persistent bottom sheet attached to the screen bottom.
- **Key Properties:** `builder`, `backgroundColor`, `elevation`, `shape`.
- **Events:** Drag and close gestures.
- **Usage Scenarios:** Persistent controls, music player, filters.

#### Speaker Notes
- Persistent BottomSheet stays visible while users interact with the main content.

---

### 2️⃣ Example
```dart
class BottomSheetExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Persistent Bottom Sheet')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 60,
                              height: 60,
                              color: Colors.purple.shade200,
                              child: Icon(Icons.music_note, size: 32),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Now Playing',
                                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text('Song Title',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('Artist Name',
                                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          ),
                          IconButton(icon: Icon(Icons.play_arrow, size: 32), onPressed: () {}),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Text('Show Bottom Sheet'),
        ),
      ),
    );
  }
}
```

---

### 3️⃣ Best Practices
- Use for persistent controls like media players.
- Add drag handle for discoverability.
- Use rounded corners for polish.
- Keep height reasonable (20-30% of screen).
- Don't block critical content.

#### Speaker Notes
- Persistent bottom sheets are great for contextual controls that need to stay visible.

---

## 1️⃣ showModalBottomSheet
### Overview
- **Purpose:** Modal bottom sheet that overlays and blocks main content.
- **Key Properties:** `builder`, `isScrollControlled`, `backgroundColor`, `shape`, `isDismissible`.
- **Events:** Dismiss gestures, barrier tap.
- **Usage Scenarios:** Forms, filters, options, detailed info, sharing.

#### Speaker Notes
- Modal bottom sheets are the preferred alternative to dialogs on mobile.

---

### 2️⃣ Example
```dart
ElevatedButton(
  onPressed: () {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filter Options',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    ListTile(
                      leading: Icon(Icons.music_note),
                      title: Text('Genre'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text('Release Date'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.star),
                      title: Text('Rating'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Reset'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            print('Filters applied');
                          },
                          child: Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  },
  child: Text('Show Modal Bottom Sheet'),
)
```

---

### 3️⃣ Best Practices
- Use `isScrollControlled: true` for tall sheets.
- Add drag handle for discoverability.
- Use rounded top corners.
- Provide clear close affordance (X button or drag).
- Use SafeArea for bottom content.
- **Recommended:** Prefer modal bottom sheets over dialogs on mobile for better UX.
- Limit height to 75% of screen for context.

#### Speaker Notes
- Modal bottom sheets feel more natural on mobile than dialogs and provide more space.

---

# 🧱 Popups & Menus

## 1️⃣ PopupMenuButton
### Overview
- **Purpose:** Display popup menu with multiple options.
- **Key Properties:** `itemBuilder`, `icon`, `onSelected`, `offset`, `elevation`, `shape`.
- **Events:** `onSelected` callback.
- **Usage Scenarios:** Context menus, overflow menus, quick actions.

#### Speaker Notes
- PopupMenuButton provides compact access to multiple actions without cluttering UI.

---

### 2️⃣ Example
```dart
PopupMenuButton<String>(
  icon: Icon(Icons.more_vert),
  offset: Offset(0, 50),
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  onSelected: (String value) {
    print('Selected: $value');
    switch (value) {
      case 'edit':
        print('Edit action');
        break;
      case 'share':
        print('Share action');
        break;
      case 'delete':
        print('Delete action');
        break;
    }
  },
  itemBuilder: (BuildContext context) => [
    PopupMenuItem(
      value: 'edit',
      child: Row(
        children: [
          Icon(Icons.edit, size: 20, color: Colors.blue),
          SizedBox(width: 12),
          Text('Edit'),
        ],
      ),
    ),
    PopupMenuItem(
      value: 'share',
      child: Row(
        children: [
          Icon(Icons.share, size: 20, color: Colors.green),
          SizedBox(width: 12),
          Text('Share'),
        ],
      ),
    ),
    PopupMenuDivider(),
    PopupMenuItem(
      value: 'delete',
      child: Row(
        children: [
          Icon(Icons.delete, size: 20, color: Colors.red),
          SizedBox(width: 12),
          Text('Delete'),
        ],
      ),
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use for 3-6 contextual actions.
- Provide clear icons and labels.
- Use `PopupMenuDivider` to group actions.
- Place destructive actions at bottom.
- Use consistent icon styling.
- Provide feedback via `onSelected`.
- Position appropriately with `offset`.

#### Speaker Notes
- PopupMenuButton is ideal for overflow actions that don't fit in the primary UI.

---

## 1️⃣ Custom Popup with showMenu
### Overview
- **Purpose:** Display custom positioned popup menu.
- **Key Properties:** `position`, `items`, `elevation`, `shape`.
- **Events:** Item selection.
- **Usage Scenarios:** Context menus, custom positioned menus, right-click menus.

#### Speaker Notes
- showMenu provides fine control over menu position and appearance.

---

### 2️⃣ Example
```dart
GestureDetector(
  onLongPress: () {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      items: [
        PopupMenuItem(
          value: 'copy',
          child: Row(
            children: [
              Icon(Icons.copy, size: 20),
              SizedBox(width: 12),
              Text('Copy'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'paste',
          child: Row(
            children: [
              Icon(Icons.paste, size: 20),
              SizedBox(width: 12),
              Text('Paste'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'select',
          child: Row(
            children: [
              Icon(Icons.select_all, size: 20),
              SizedBox(width: 12),
              Text('Select All'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        print('Selected: $value');
      }
    });
  },
  child: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue.shade100,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text('Long press for menu'),
  ),
)
```

---

### 3️⃣ Best Practices
- Calculate position based on tap location.
- Use for context-sensitive menus.
- Provide clear action labels.
- Handle menu dismissal gracefully.
- Use for right-click menus on desktop.

#### Speaker Notes
- showMenu is powerful for context menus that need precise positioning.

---

## 1️⃣ Tooltip
### Overview
- **Purpose:** Display helpful text on long press or hover.
- **Key Properties:** `message`, `child`, `preferBelow`, `verticalOffset`, `decoration`.
- **Events:** None (automatic on hover/long press).
- **Usage Scenarios:** Icon explanations, accessibility, helper text, abbreviations.

#### Speaker Notes
- Tooltips enhance usability by explaining icons and providing context.

---

### 2️⃣ Example
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Tooltip(
      message: 'Add to favorites',
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TextStyle(color: Colors.white, fontSize: 14),
      child: IconButton(
        icon: Icon(Icons.favorite_border),
        onPressed: () {},
      ),
    ),
    Tooltip(
      message: 'Share with friends',
      preferBelow: false,
      child: IconButton(
        icon: Icon(Icons.share),
        onPressed: () {},
      ),
    ),
    Tooltip(
      message: 'Download for offline',
      child: IconButton(
        icon: Icon(Icons.download),
        onPressed: () {},
      ),
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use for all icon-only buttons.
- Keep messages concise and helpful.
- Essential for accessibility.
- Customize appearance to match theme.
- Use `preferBelow` to control position.
- Avoid for obvious actions.

#### Speaker Notes
- Tooltips are critical for accessibility and explaining non-obvious UI elements.

---

# 📊 Summary & Key Takeaways

---

## Final Summary
- AlertDialog for critical decisions and confirmations.
- SimpleDialog for option selection.
- Modal bottom sheets preferred over dialogs on mobile.
- PopupMenuButton for overflow and context menus.
- Tooltips essential for icon-only buttons and accessibility.

## Key Takeaway
- Choose the right overlay for the context:
  - AlertDialog: Critical decisions (2-3 actions)
  - SimpleDialog: Option selection (4-6 items)
  - Modal Bottom Sheet: Mobile-friendly forms/filters
  - PopupMenuButton: Overflow actions
  - Tooltip: Icon explanations
- **Prefer modal bottom sheets over dialogs on mobile for better UX.**

## Optimization Principles
- Keep dialog content concise and scannable.
- Provide clear action buttons with appropriate colors.
- Use bottom sheets for mobile, dialogs for desktop.
- Add drag handles to bottom sheets for discoverability.
- Use tooltips for all icon-only buttons.
- Test overlays on different screen sizes.
- Use `barrierDismissible: false` for critical dialogs.
- Position menus appropriately with `offset`.

---

> ![🎯](https://img.icons8.com/color/48/000000/goal.png) **Well-designed overlays enhance UX without disrupting the user's flow!**
