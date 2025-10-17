# 🎭 Dialogs & Sheets in Flutter
## Overlay Components

> A comprehensive guide to implementing Dialogs, Bottom Sheets, and Side Sheets following Material Design 3 guidelines and Flutter best practices.

---

## 📋 Table of Contents

1. [Introduction to Overlay Components](#-introduction-to-overlay-components)
2. [🔴 Dialogs](#-dialogs)
   - Overview
   - Implementation
   - Best Practices
3. [🔵 Bottom Sheets](#-bottom-sheets)
   - Overview
   - Implementation
   - Best Practices
4. [🟢 Side Sheets](#-side-sheets)
   - Overview
   - Implementation
   - Best Practices
5. [🧭 Decision Framework](#-decision-framework)
6. [📌 Summary](#-summary)

---

## 🎯 Introduction to Overlay Components

### What Are Overlay Components?

**Overlay components** are temporary UI surfaces that appear above the main content to:
- ✅ Present critical information or choices
- ✅ Capture user input without navigation
- ✅ Provide contextual actions or settings
- ✅ Maintain workflow continuity

### The Three Primary Types

| Component | Visual Position | Modality | Best For |
|-----------|----------------|----------|----------|
| **Dialog** | Center overlay | Modal | Urgent decisions, alerts |
| **Bottom Sheet** | Bottom edge | Modal/Standard | Mobile actions, filters |
| **Side Sheet** | Right edge | Modal/Standard | Desktop forms, settings |

### Material Design 3 Principles

1. **Purposeful Interruption**: Only interrupt when necessary
2. **Clear Affordances**: Make dismissal and actions obvious
3. **Responsive Design**: Adapt to screen size and orientation
4. **Accessible by Default**: Support keyboard, screen readers, and gestures

> 📚 **References**: [M3 Components Overview](https://m3.material.io/components)

**Speaker Notes**: Overlay components are fundamental to modern app UX. They allow users to stay in context while completing secondary tasks. The key is choosing the right component for the right situation—we'll explore a decision framework later.

---

## 🔴 DIALOGS

---

### 📊 Dialogs: Overview

#### Purpose & Use Cases

**Dialogs interrupt the user flow to:**
- ⚠️ Display critical alerts or errors
- ✅ Request confirmation for destructive actions
- 🔐 Obtain permissions or consent
- 📝 Capture simple, focused input

#### Real-World Usage Scenarios

```
✓ "Delete account? This cannot be undone" (Confirmation)
✓ "Error: Payment failed. Retry?" (Alert)
✓ "Allow camera access?" (Permission)
✓ "Unsaved changes. Save or discard?" (Decision)
✓ "Select your preferred language" (Simple selection)
```

#### Dialog Types

| Type | Purpose | Max Width | Scrollable |
|------|---------|-----------|------------|
| **Alert Dialog** | Simple decisions, 1-2 actions | 280-560dp | Optional |
| **Confirmation Dialog** | Yes/No, destructive actions | 280-560dp | No |
| **Full-Screen Dialog** | Complex forms, multi-step | 100% width | Yes |

#### Key Properties & Events

```dart
AlertDialog(
  icon: Icon(Icons.warning),          // Optional visual identifier
  title: Text('Delete Item?'),        // Required: Clear heading
  content: Text('Cannot be undone'),  // Optional: Supporting text
  actions: [                          // 1-3 action buttons
    TextButton(child: Text('Cancel')),
    FilledButton(child: Text('Delete')),
  ],
)
```

**Properties:**
- `icon`: Visual cue for dialog purpose (M3 enhancement)
- `title`: Main heading (required for accessibility)
- `content`: Supporting text or widgets (can be scrollable)
- `actions`: 1-3 buttons (cancel + primary action)
- `scrollable`: Enable for long content
- `barrierDismissible`: Allow tap-outside to dismiss (default: true for non-critical)

**Events:**
- `onPressed`: Handle button taps
- `Navigator.pop(context, result)`: Return data when dismissed

**Speaker Notes**: Dialogs are the most interruptive component—use them only when user attention is required immediately. The icon property in M3 helps users quickly identify dialog purpose. Full-screen dialogs are essentially separate pages with dialog-style navigation.

---

### 💻 Dialogs: Implementation

#### Basic Alert Dialog

```dart
// ✓ Good: Clear purpose, concise content, visible actions
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    icon: const Icon(Icons.delete_outline),
    title: const Text('Delete Item?'),
    content: const Text(
      'This action cannot be undone. The item will be permanently deleted.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, true),
        child: const Text('Delete'),
      ),
    ],
  ),
).then((confirmed) {
  if (confirmed == true) {
    // Perform deletion
  }
});
```

#### List Selection Dialog

```dart
// Use SimpleDialog for radio-button style selections
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Select Ringtone'),
    content: SingleChildScrollView(  // Handle overflow
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            title: const Text('Default'),
            value: 'default',
            groupValue: selectedRingtone,
            onChanged: (value) => Navigator.pop(context, value),
          ),
          RadioListTile(
            title: const Text('Classical'),
            value: 'classical',
            groupValue: selectedRingtone,
            onChanged: (value) => Navigator.pop(context, value),
          ),
          // More options...
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    ],
  ),
);
```

#### Full-Screen Dialog (Complex Forms)

```dart
// Navigate to full-screen dialog using route
Navigator.of(context).push(
  MaterialPageRoute(
    fullscreenDialog: true,  // Important: Shows X instead of back arrow
    builder: (context) => Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () => _saveAndClose(context),
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v?.contains('@') ?? false ? null : 'Invalid email',
              ),
              SwitchListTile(
                title: const Text('Enable Notifications'),
                value: notificationsEnabled,
                onChanged: (v) => setState(() => notificationsEnabled = v),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);
```

#### Returning Data from Dialogs

```dart
// Pattern 1: Return simple boolean
final confirmed = await showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Confirm?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('No'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, true),
        child: const Text('Yes'),
      ),
    ],
  ),
);

if (confirmed == true) {
  // User confirmed
}

// Pattern 2: Return complex data
final result = await showDialog<UserProfile>(
  context: context,
  builder: (context) => ProfileEditDialog(),
);

if (result != null) {
  // User saved changes, update UI with result
  setState(() => userProfile = result);
}
```

**Speaker Notes**: The fullscreenDialog property is critical—it changes the back button to a close X, signaling to users this is a separate flow. Always validate forms before closing. Use generic types with showDialog to get type-safe return values.

---

### ✅ Dialogs: Best Practices

#### UX Guidelines

**DO:**
- ✅ Use for critical, time-sensitive decisions
- ✅ Keep content concise (2-3 lines max for basic dialogs)
- ✅ Provide 1-3 clear action buttons
- ✅ Use destructive action styling (error color) for dangerous operations
- ✅ Include icons to reinforce purpose
- ✅ Make non-critical dialogs dismissible by tapping outside
- ✅ Return data using `Navigator.pop(context, result)`

**DON'T:**
- ❌ Show dialogs on initial app load
- ❌ Use for long forms (use full-screen dialog or dedicated page)
- ❌ Stack multiple dialogs
- ❌ Use for non-urgent information (use SnackBar instead)
- ❌ Forget to provide a cancel/dismiss option
- ❌ Use jargon or technical errors in user-facing messages

#### Performance Optimization

```dart
// ✓ Good: Lazy-build dialog content
showDialog(
  context: context,
  builder: (context) => const MyDialog(),  // Built only when shown
);

// ✗ Bad: Pre-building dialog unnecessarily
final dialog = MyDialog();  // Built immediately
showDialog(
  context: context,
  builder: (context) => dialog,
);

// ✓ Good: Dispose controllers in full-screen dialogs
class ProfileDialog extends StatefulWidget {
  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  late final TextEditingController _nameController;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }
  
  @override
  void dispose() {
    _nameController.dispose();  // Prevent memory leaks
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

#### Common Pitfalls to Avoid

| Pitfall | Impact | Solution |
|---------|--------|----------|
| No cancel option | User feels trapped | Always provide dismiss affordance |
| Unclear primary action | Confusion, errors | Use FilledButton for primary, TextButton for cancel |
| Too much text | Poor readability | Keep to 1-3 sentences; use full-screen for more |
| Multiple dialogs | Overwhelming UX | Queue or combine messages |
| barrierDismissible=false | Frustration | Reserve for critical, must-complete actions only |

#### Accessibility Best Practices

```dart
// ✓ Semantic labels for screen readers
AlertDialog(
  title: const Text('Delete Item?'),
  content: const Text('This cannot be undone'),
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Cancel'),
    ),
    FilledButton(
      onPressed: () => Navigator.pop(context, true),
      child: Semantics(
        label: 'Confirm deletion',  // Clear screen reader announcement
        child: const Text('Delete'),
      ),
    ),
  ],
)
```

#### Comparison with Alternatives

| Scenario | Dialog | Alternative | Reasoning |
|----------|--------|-------------|-----------|
| Network error | ✅ AlertDialog | SnackBar | If blocks app usage → Dialog; if minor → SnackBar |
| Success message | ❌ | ✅ SnackBar | Non-blocking feedback is less disruptive |
| Quick filter | ❌ | ✅ Bottom Sheet | Doesn't require urgent attention |
| Multi-step form | ❌ | ✅ Full-screen dialog / New page | Better UX for complex input |
| Destructive action | ✅ Confirmation Dialog | - | Prevents accidental data loss |

**Speaker Notes**: The biggest mistake is overusing dialogs. They're interruptive by design—reserve them for truly important moments. For success confirmations, a SnackBar is almost always better. Notice how M3 uses FilledButton for primary actions to guide the user's eye.

---

## 🔵 BOTTOM SHEETS

---

### 📊 Bottom Sheets: Overview

#### Purpose & Use Cases

**Bottom Sheets slide from the bottom to:**
- 🎯 Present quick actions contextual to current content
- 🔍 Provide filtering or sorting options
- 📤 Show sharing or export options
- 📝 Capture short-form input (2-5 fields)
- 📋 Display supplementary information

#### Real-World Usage Scenarios

```
✓ Social media share options (Standard)
✓ Photo upload: Camera or Gallery (Modal)
✓ Map filter: Distance, Price, Rating (Standard)
✓ E-commerce sort: Price, Rating, Newest (Standard)
✓ Quick note creation with title + body (Modal)
✓ Music player queue (Standard, persistent)
```

#### Bottom Sheet Variants

| Type | Interaction | Scrim | Use Case |
|------|-------------|-------|----------|
| **Standard** | Non-blocking | None | Quick actions, can interact with background |
| **Modal** | Blocking | Dark overlay | Focused tasks requiring user decision |

#### Key Properties & Events

```dart
// Standard Bottom Sheet
showBottomSheet(
  context: context,
  builder: (context) => MyBottomSheet(),
);

// Modal Bottom Sheet
showModalBottomSheet(
  context: context,
  isDismissible: true,           // Tap outside to dismiss
  isScrollControlled: false,     // Full-height when true
  showDragHandle: true,          // M3 drag handle
  enableDrag: true,              // Swipe down to dismiss
  builder: (context) => MyBottomSheet(),
);
```

**Properties:**
- `showDragHandle`: M3 visual affordance for dismissal
- `isDismissible`: Allow tap-outside dismiss (default: true)
- `enableDrag`: Allow swipe-down dismiss (default: true)
- `isScrollControlled`: Use full screen height (for long content)
- `shape`: Rounded corners (M3: `RoundedRectangleBorder(borderRadius: ...)`)
- `backgroundColor`: Custom background (defaults to surface color)

**Events:**
- Dismiss via swipe, tap outside, or `Navigator.pop(context, result)`
- Returns data when closed: `final result = await showModalBottomSheet(...)`

**Speaker Notes**: Bottom sheets are mobile-first components—they feel natural on phones and tablets but awkward on desktop. Modal sheets dim the background, standard sheets don't. The drag handle in M3 is a small visual improvement that dramatically improves discoverability.

---

### 💻 Bottom Sheets: Implementation

#### Standard Bottom Sheet (Non-Modal)

```dart
// Standard: User can interact with background content
void _showStandardBottomSheet(BuildContext context) {
  showBottomSheet(
    context: context,
    builder: (context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
              // Handle share
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Download'),
            onTap: () {
              Navigator.pop(context);
              // Handle download
            },
          ),
        ],
      ),
    ),
  );
}
```

#### Modal Bottom Sheet (Blocking)

```dart
// Modal: Requires user interaction, blocks background
Future<void> _showModalBottomSheet(BuildContext context) async {
  final result = await showModalBottomSheet<String>(
    context: context,
    isDismissible: true,
    showDragHandle: true,  // M3 drag handle
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Options',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('All'),
                selected: true,
                onSelected: (selected) {},
              ),
              FilterChip(
                label: const Text('Recent'),
                selected: false,
                onSelected: (selected) {},
              ),
              FilterChip(
                label: const Text('Favorites'),
                selected: false,
                onSelected: (selected) {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => Navigator.pop(context, 'applied'),
                child: const Text('Apply'),
              ),
            ],
          ),
          // Safe area for home indicator
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    ),
  );
  
  if (result == 'applied') {
    // Handle filter application
  }
}
```

#### Full-Height Scrollable Bottom Sheet

```dart
// isScrollControlled: true for long content
showModalBottomSheet(
  context: context,
  isScrollControlled: true,  // Allows full screen height
  showDragHandle: true,
  builder: (context) => DraggableScrollableSheet(
    initialChildSize: 0.6,  // Start at 60% height
    minChildSize: 0.4,      // Minimum 40% height
    maxChildSize: 0.95,     // Maximum 95% height
    expand: false,
    builder: (context, scrollController) {
      return SingleChildScrollView(
        controller: scrollController,  // Important: Connect scroll
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            // Long scrollable content...
            ...List.generate(
              20,
              (index) => ListTile(
                title: Text('Item ${index + 1}'),
                subtitle: Text('Description for item ${index + 1}'),
              ),
            ),
          ],
        ),
      );
    },
  ),
);
```

#### Bottom Sheet with Form Input

```dart
// Keyboard-aware bottom sheet
showModalBottomSheet(
  context: context,
  isScrollControlled: true,  // Required for keyboard avoidance
  showDragHandle: true,
  builder: (context) => Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,  // Keyboard height
      left: 16,
      right: 16,
      top: 16,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Quick Note',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Save'),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    ),
  ),
);
```

**Speaker Notes**: The difference between standard and modal is subtle but important—modal dims the background and prevents interaction. DraggableScrollableSheet is powerful for content that varies in length. Always account for safe areas (home indicator, keyboard) using MediaQuery.

---

### ✅ Bottom Sheets: Best Practices

#### UX Guidelines

**DO:**
- ✅ Use on mobile and tablet layouts (compact to medium screens)
- ✅ Include drag handle for clear dismissal affordance
- ✅ Keep content focused (3-8 options ideal)
- ✅ Add safe area padding for home indicators
- ✅ Use modal variant for decision-requiring tasks
- ✅ Provide explicit "Apply" or "Done" buttons for modal sheets
- ✅ Make sheets dismissible via swipe, tap outside, or close button

**DON'T:**
- ❌ Use on desktop/large screens (use dialogs or side sheets instead)
- ❌ Show critical alerts (use dialogs)
- ❌ Include infinite scrolling lists (use full page)
- ❌ Disable drag dismissal without good reason
- ❌ Forget keyboard avoidance when using text fields
- ❌ Nest bottom sheets

#### Performance Optimization

```dart
// ✓ Good: Efficient builder
showModalBottomSheet(
  context: context,
  builder: (context) => const MyBottomSheet(),  // Const constructor
);

// ✓ Good: Handle keyboard efficiently
Padding(
  padding: EdgeInsets.only(
    bottom: MediaQuery.of(context).viewInsets.bottom,  // Only rebuilds for keyboard
  ),
  child: const MyForm(),
)

// ✗ Bad: Building content outside builder
final sheet = MyBottomSheet();  // Built unnecessarily
showModalBottomSheet(
  context: context,
  builder: (context) => sheet,
);

// ✓ Good: Lazy-load heavy content
builder: (context) {
  return FutureBuilder(
    future: loadHeavyData(),  // Only loads when sheet shown
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return MyContent(snapshot.data);
      }
      return const CircularProgressIndicator();
    },
  );
}
```

#### Common Pitfalls to Avoid

| Pitfall | Impact | Solution |
|---------|--------|----------|
| No drag handle | Users don't know sheet is dismissible | Always use `showDragHandle: true` in M3 |
| Missing safe area | Content hidden behind home indicator | Add `MediaQuery.of(context).padding.bottom` |
| Fixed height with keyboard | Input fields hidden | Use `isScrollControlled: true` + `viewInsets.bottom` |
| Too many options | Overwhelming, poor scrollability | Limit to 8 items; use full page for more |
| Standard on desktop | Awkward UX | Detect screen size, use side sheet on desktop |

#### Responsive Design Pattern

```dart
// ✓ Good: Adapt to screen size
void _showResponsiveSheet(BuildContext context) {
  final isLargeScreen = MediaQuery.of(context).size.width > 600;
  
  if (isLargeScreen) {
    // Desktop/tablet: Use side sheet
    _showSideSheet(context);
  } else {
    // Mobile: Use bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (context) => const MySheet(),
    );
  }
}
```

#### Comparison with Alternatives

| Scenario | Bottom Sheet | Alternative | Reasoning |
|----------|--------------|-------------|-----------|
| Mobile filters | ✅ Modal Bottom Sheet | Side Sheet | Natural on mobile, touch-friendly |
| Desktop filters | ❌ | ✅ Side Sheet | Better ergonomics on large screens |
| Share menu | ✅ Standard Bottom Sheet | - | Quick action, doesn't require decision |
| Long form (10+ fields) | ❌ | ✅ Full page | Too much content for sheet |
| Critical error | ❌ | ✅ Dialog | Requires immediate attention |

**Speaker Notes**: Bottom sheets shine on mobile—they're easy to swipe away and feel natural with touch gestures. The drag handle seems like a small detail but it's a huge usability win. Always test with keyboard visible to ensure fields aren't obscured. Remember: if it feels awkward on desktop, use a side sheet instead.

---

## 🟢 SIDE SHEETS

---

### 📊 Side Sheets: Overview

#### Purpose & Use Cases

**Side Sheets slide from the right edge to:**
- ⚙️ Provide detailed settings or preferences
- 🔍 Show advanced filtering options
- 📝 Display contextual forms (5-15 fields)
- 📊 Present supplementary data or analytics
- 🛠️ Offer tool palettes or property editors

#### Real-World Usage Scenarios

```
✓ E-commerce product filters: Price, Size, Color (Standard)
✓ Email compose pane in inbox view (Modal)
✓ Calendar event editor (Modal)
✓ Dashboard widget settings panel (Standard)
✓ Document properties and metadata (Standard)
✓ Image editor tool palette (Standard)
```

#### Side Sheet Variants

| Type | Interaction | Scrim | Use Case |
|------|-------------|-------|----------|
| **Standard** | Non-blocking | None | Contextual tools, allows viewing main content |
| **Modal** | Blocking | Dark overlay | Forms requiring focused input |

#### Key Properties & Events

```dart
// Side sheets use showGeneralDialog for custom positioning
showGeneralDialog(
  context: context,
  barrierDismissible: true,
  barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  barrierColor: Colors.black.withOpacity(0.5),  // Modal: dark; Standard: transparent
  transitionDuration: const Duration(milliseconds: 300),
  pageBuilder: (context, animation, secondaryAnimation) {
    return Align(
      alignment: Alignment.centerRight,  // Right edge
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),  // Start off-screen right
          end: Offset.zero,           // End at right edge
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        )),
        child: MySideSheet(),
      ),
    );
  },
);
```

**Properties:**
- `barrierColor`: `Colors.transparent` (standard) vs `Colors.black.withOpacity(0.5)` (modal)
- `barrierDismissible`: Allow tap-outside dismiss
- `alignment`: `Alignment.centerRight` (right edge) or `Alignment.centerLeft` (left edge)
- Width: Typically 360dp (modal) or 256-400dp (standard)

**Events:**
- Dismiss via tap outside, close button, or `Navigator.pop(context, result)`
- Animation transitions: slide from edge with easing curve

**Speaker Notes**: Side sheets are the desktop/tablet equivalent of bottom sheets. They're rare on phones but essential on larger screens where horizontal space is abundant. The key differentiator is modality—standard side sheets let users reference the main content while adjusting settings.

---

### 💻 Side Sheets: Implementation

#### Standard Side Sheet (Non-Modal)

```dart
// Standard: Clear background, allows main content interaction
void _showStandardSideSheet(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,  // No dimming
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.centerRight,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: Material(
            elevation: 8,
            child: Container(
              width: 320,  // Standard width
              height: double.infinity,
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          'Filters',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(
                          'Price Range',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        RangeSlider(
                          values: const RangeValues(20, 80),
                          onChanged: (values) {},
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Category',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        CheckboxListTile(
                          title: const Text('Electronics'),
                          value: true,
                          onChanged: (v) {},
                        ),
                        CheckboxListTile(
                          title: const Text('Clothing'),
                          value: false,
                          onChanged: (v) {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
```

#### Modal Side Sheet (Blocking)

```dart
// Modal: Dimmed background, requires user attention
void _showModalSideSheet(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),  // Semi-transparent overlay
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.centerRight,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: _ModalSideSheetContent(),
        ),
      );
    },
  );
}

// Extracted widget for complex side sheet
class _ModalSideSheetContent extends StatefulWidget {
  @override
  State<_ModalSideSheetContent> createState() => _ModalSideSheetContentState();
}

class _ModalSideSheetContentState extends State<_ModalSideSheetContent> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String _priority = 'Medium';
  DateTime _dueDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 360,  // M3 standard modal width
        height: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Create Task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Task Title',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Priority',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'Low', label: Text('Low')),
                          ButtonSegment(value: 'Medium', label: Text('Medium')),
                          ButtonSegment(value: 'High', label: Text('High')),
                        ],
                        selected: {_priority},
                        onSelectionChanged: (v) => setState(() => _priority = v.first),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(_dueDate.toString().split(' ')[0]),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _dueDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) setState(() => _dueDate = date);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Theme.of(context).colorScheme.outline),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Task "${_titleController.text}" created')),
                          );
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Speaker Notes**: Notice the width differences—standard sheets are narrower (256-320dp) since they coexist with content, while modal sheets are wider (360dp) for focused tasks. Always provide both a back arrow and close X for modal sheets to match user expectations from mobile platforms.

---

### ✅ Side Sheets: Best Practices

#### UX Guidelines

**DO:**
- ✅ Use on tablet and desktop layouts (medium to large screens)
- ✅ Set appropriate widths: 256-320dp (standard), 360dp (modal)
- ✅ Provide close button in header
- ✅ Use modal variant for forms requiring focused input
- ✅ Include scrollable content for long forms
- ✅ Add elevation/shadow for depth perception
- ✅ Animate slide-in from right edge

**DON'T:**
- ❌ Use on mobile/phone layouts (use bottom sheets instead)
- ❌ Make sheets full-width (defeats the purpose)
- ❌ Cover critical main content (position thoughtfully)
- ❌ Use for urgent alerts (use dialogs)
- ❌ Nest side sheets
- ❌ Forget to handle keyboard focus management

#### Performance Optimization

```dart
// ✓ Good: Const where possible
showGeneralDialog(
  context: context,
  pageBuilder: (context, animation, secondaryAnimation) {
    return Align(
      alignment: Alignment.centerRight,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: const MySideSheet(),  // Const constructor
      ),
    );
  },
);

// ✓ Good: Dispose controllers
class MySideSheetState extends State<MySideSheet> {
  late final TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// ✓ Good: Debounce expensive operations
Timer? _debounce;

void _onFilterChanged(String value) {
  _debounce?.cancel();
  _debounce = Timer(const Duration(milliseconds: 300), () {
    // Expensive filtering operation
  });
}

@override
void dispose() {
  _debounce?.cancel();
  super.dispose();
}
```

#### Common Pitfalls to Avoid

| Pitfall | Impact | Solution |
|---------|--------|----------|
| Using on mobile | Poor UX, wastes vertical space | Detect screen size, use bottom sheet on mobile |
| Full-width sheet | Loses context of main content | Max 360dp width for modal, 320dp for standard |
| No header/close | Users feel trapped | Always include close affordance in header |
| Abrupt appearance | Jarring UX | Use slide transition with easing curve |
| Modal for reference data | Unnecessary blocking | Use standard variant for non-critical content |

#### Responsive Design Pattern

```dart
// ✓ Comprehensive responsive pattern
void _showResponsiveFilterSheet(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  
  if (screenWidth < 600) {
    // Mobile: Bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (context) => const FilterBottomSheet(),
    );
  } else {
    // Tablet/Desktop: Side sheet
    showGeneralDialog(
      context: context,
      barrierColor: screenWidth > 900
          ? Colors.transparent  // Large screen: standard
          : Colors.black.withOpacity(0.5),  // Medium: modal
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: FilterSideSheet(
              width: screenWidth > 900 ? 320 : 360,
            ),
          ),
        );
      },
    );
  }
}
```

#### Comparison with Alternatives

| Scenario | Side Sheet | Alternative | Reasoning |
|----------|------------|-------------|-----------|
| Desktop filters | ✅ Standard Side Sheet | Bottom Sheet | Better use of horizontal space |
| Mobile filters | ❌ | ✅ Bottom Sheet | Vertical space more limited |
| Desktop form (10+ fields) | ✅ Modal Side Sheet | Full page | Maintains context with main content |
| Critical alert | ❌ | ✅ Dialog | Requires center focus |
| Settings panel | ✅ Standard Side Sheet | - | Non-blocking, contextual |

**Speaker Notes**: Side sheets are underutilized in Flutter apps—developers often default to bottom sheets even on desktop. A good rule: if there's more horizontal than vertical space, consider a side sheet. The animation is important—slide from edge feels natural and helps users understand where the content came from. Always make modal sheets dismissible to avoid frustration.

---

## 🧭 DECISION FRAMEWORK

---

### 📊 Component Comparison Matrix

| Criteria | Dialog | Bottom Sheet | Side Sheet |
|----------|--------|--------------|------------|
| **Purpose** | Urgent interruptions, critical decisions | Quick actions, supplementary content | Contextual tools, detailed settings |
| **Modality** | Always modal | Modal or Standard | Modal or Standard |
| **Position** | Center overlay | Bottom edge | Right edge (rarely left) |
| **Best Screen Size** | All sizes | Mobile, Tablet | Tablet, Desktop |
| **Interaction Model** | Must respond before continuing | Can dismiss easily (swipe/tap) | Can coexist with main content |
| **User Flow** | Blocking, requires decision | Supplementary, optional | Parallel, contextual |
| **Content Length** | Short (2-3 lines) or Full-screen | Short to medium (1 screen) | Medium to long (scrollable) |
| **Use Frequency** | Rare (critical moments) | Common (contextual actions) | Moderate (detailed tasks) |
| **Dismissal** | Button action (sometimes tap outside) | Swipe, tap outside, button | Tap outside, close button |
| **Primary Use Cases** | Alerts, confirmations, permissions | Filters, shares, quick forms | Filters, settings, complex forms |

**Speaker Notes**: Use this table as a quick reference. The key differentiators are urgency (Dialog > Bottom Sheet > Side Sheet) and screen size (Side Sheet = desktop, Bottom Sheet = mobile, Dialog = universal).

---

### 🌳 Decision Tree

```
Start: Need to show overlay content
│
├─ Is this URGENT and requires IMMEDIATE attention?
│  ├─ YES → Use DIALOG
│  │   ├─ Simple decision (1-3 actions)? → AlertDialog
│  │   ├─ List selection? → AlertDialog with ListView
│  │   └─ Complex form (5+ fields)? → Full-Screen Dialog
│  │
│  └─ NO → Continue
│      │
│      ├─ Is screen width > 600dp (tablet/desktop)?
│      │  ├─ YES → Use SIDE SHEET
│      │  │   ├─ Needs focused input? → Modal Side Sheet
│      │  │   └─ Reference/tool palette? → Standard Side Sheet
│      │  │
│      │  └─ NO (mobile) → Use BOTTOM SHEET
│      │      ├─ Requires user decision? → Modal Bottom Sheet
│      │      └─ Quick actions/info? → Standard Bottom Sheet
│
└─ Special Cases:
    ├─ Success message → SnackBar (not overlay)
    ├─ Long form (15+ fields) → Full page (not overlay)
    └─ Persistent controls → App bar / FAB (not overlay)
```

**Speaker Notes**: Follow this tree for 90% of cases. Start with urgency—if it's critical, it's a dialog. Then consider screen size. The special cases are important: not everything needs an overlay.

---

### 🎯 Real-World Scenarios

#### Scenario 1: E-Commerce Product Filters

**Context**: User browsing product catalog, wants to filter by price, size, color

**Decision**:
- 📱 **Mobile**: Modal Bottom Sheet
  - **Why**: Touch-friendly, natural swipe gestures, doesn't cover products
  - **Implementation**: `showModalBottomSheet` with FilterChips and RangeSlider
- 🖥️ **Desktop**: Standard Side Sheet
  - **Why**: Horizontal space available, user can see products while filtering
  - **Implementation**: `showGeneralDialog` with `barrierColor: Colors.transparent`

**Code Pattern**:
```dart
final isDesktop = MediaQuery.of(context).size.width > 600;
if (isDesktop) {
  _showFilterSideSheet(context);
} else {
  _showFilterBottomSheet(context);
}
```

---

#### Scenario 2: Destructive Action (Delete Account)

**Context**: User clicked "Delete Account" in settings

**Decision**: **Alert Dialog** (Confirmation)

**Why**:
- ⚠️ Critical, irreversible action
- 🛑 Must interrupt user flow
- 📱 Works on all screen sizes
- ✅ Clear yes/no decision

**Implementation**:
```dart
showDialog(
  context: context,
  barrierDismissible: false,  // Force explicit choice
  builder: (context) => AlertDialog(
    icon: const Icon(Icons.warning, color: Colors.red),
    title: const Text('Delete Account?'),
    content: const Text(
      'This action is permanent. All your data will be lost.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Cancel'),
      ),
      FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: () => Navigator.pop(context, true),
        child: const Text('Delete'),
      ),
    ],
  ),
);
```

---

#### Scenario 3: Email Compose

**Context**: User wants to compose email while viewing inbox

**Decision**:
- 📱 **Mobile**: Full-Screen Dialog
  - **Why**: Needs full attention, multiple fields, can't see inbox anyway
  - **Implementation**: `MaterialPageRoute(fullscreenDialog: true)`
- 🖥️ **Desktop**: Modal Side Sheet
  - **Why**: Can reference inbox while composing, natural email client pattern
  - **Implementation**: `showGeneralDialog` with 360dp width

**Code Pattern**:
```dart
final isMobile = MediaQuery.of(context).size.width < 600;
if (isMobile) {
  Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => const ComposeEmailScreen(),
    ),
  );
} else {
  _showComposeEmailSideSheet(context);
}
```

---

#### Scenario 4: Social Media Share

**Context**: User taps share button on a post

**Decision**: **Standard Bottom Sheet**

**Why**:
- 🎯 Quick action, doesn't require decision
- 👆 Touch-friendly share icons
- 🚫 Non-blocking (user can dismiss easily)
- 📱 Universal mobile pattern

**Implementation**:
```dart
showModalBottomSheet(
  context: context,
  showDragHandle: true,
  builder: (context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListTile(
        leading: const Icon(Icons.copy),
        title: const Text('Copy Link'),
        onTap: () => _shareVia(context, 'copy'),
      ),
      ListTile(
        leading: const Icon(Icons.message),
        title: const Text('Send Message'),
        onTap: () => _shareVia(context, 'message'),
      ),
      ListTile(
        leading: const Icon(Icons.email),
        title: const Text('Email'),
        onTap: () => _shareVia(context, 'email'),
      ),
    ],
  ),
);
```

---

#### Scenario 5: Dashboard Widget Settings

**Context**: User clicks settings icon on a dashboard widget

**Decision**:
- 📱 **Mobile**: Modal Bottom Sheet
  - **Why**: Focused task, doesn't need to see widget while editing
- 🖥️ **Desktop**: Standard Side Sheet
  - **Why**: Can preview changes in real-time while adjusting settings

**Implementation** (Desktop):
```dart
showGeneralDialog(
  context: context,
  barrierColor: Colors.transparent,
  pageBuilder: (context, animation, secondaryAnimation) {
    return Align(
      alignment: Alignment.centerRight,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: WidgetSettingsSideSheet(
          onSettingChanged: (settings) {
            // Real-time preview updates
            setState(() => widgetSettings = settings);
          },
        ),
      ),
    );
  },
);
```

---

### ✅ Quick Reference Decision Checklist

Use this checklist to decide which component to use:

1. **Is it critical/urgent?**
   - ✅ YES → **Dialog**
   - ❌ NO → Continue to #2

2. **What's the screen width?**
   - 📱 < 600dp (Mobile) → Continue to #3
   - 🖥️ ≥ 600dp (Tablet/Desktop) → Continue to #4

3. **Mobile: Does it require a decision?**
   - ✅ YES → **Modal Bottom Sheet**
   - ❌ NO → **Standard Bottom Sheet**

4. **Desktop: Does it require focused input?**
   - ✅ YES → **Modal Side Sheet**
   - ❌ NO → **Standard Side Sheet**

**Exception Cases**:
- 🎉 Success message → **SnackBar**
- 📄 Very long form (15+ fields) → **Full Page**
- 🔄 Loading state → **Progress Indicator** (not overlay)

**Speaker Notes**: Print this checklist and keep it handy. It covers 95% of scenarios. When in doubt, prototype both options and user-test—UX is often context-dependent.

---

## 📌 SUMMARY

---

### 🎓 Key Takeaways

#### Component Selection Principles

1. **Urgency First**: Critical alerts = Dialog, everything else = Sheet
2. **Screen Size Matters**: Mobile = Bottom Sheet, Desktop = Side Sheet
3. **Modality Intentionally**: Block interaction only when decision required
4. **Content Length**: Short = Dialog, Medium = Sheet, Long = Full Page
5. **User Context**: Enhance workflow, don't interrupt unless necessary

---

### ✅ Quick Reference Checklist

| Component | When to Use | Key Properties |
|-----------|-------------|----------------|
| **Alert Dialog** | Critical decisions, confirmations | `icon`, `title`, `content`, `actions` |
| **List Dialog** | Simple selections (5-10 options) | `AlertDialog` + `ListView` |
| **Full-Screen Dialog** | Complex forms on mobile | `fullscreenDialog: true` route |
| **Modal Bottom Sheet** | Mobile focused tasks | `showModalBottomSheet`, `showDragHandle: true` |
| **Standard Bottom Sheet** | Mobile quick actions | `showBottomSheet`, clear background |
| **Modal Side Sheet** | Desktop focused forms | `showGeneralDialog`, 360dp width, scrim |
| **Standard Side Sheet** | Desktop contextual tools | `showGeneralDialog`, 320dp width, no scrim |

---

### 🚀 Optimization Principles

#### Performance
- ✅ Use `const` constructors when possible
- ✅ Lazy-build content in `builder` functions
- ✅ Dispose controllers in `dispose()` method
- ✅ Debounce expensive operations (filtering, search)
- ✅ Use `ListView.builder` for long lists

#### Accessibility
- ✅ Provide semantic labels for screen readers
- ✅ Ensure keyboard navigation support
- ✅ Use sufficient color contrast (WCAG AA minimum)
- ✅ Test with screen reader (TalkBack/VoiceOver)
- ✅ Provide alternative dismiss methods

#### UX
- ✅ Always provide clear dismiss affordance
- ✅ Use M3 drag handle for bottom sheets
- ✅ Add safe area padding (home indicator, keyboard)
- ✅ Animate transitions smoothly (300ms easing curve)
- ✅ Return data on dismissal for programmatic handling

---

### 🎯 Common Anti-Patterns to Avoid

| Anti-Pattern | Why It's Bad | Solution |
|--------------|--------------|----------|
| Dialog on app launch | Interrupts onboarding | Use welcome screen or tour |
| Nested overlays | Confusing, overwhelming | Queue or combine messages |
| Bottom sheet on desktop | Awkward ergonomics | Use side sheet instead |
| No dismiss affordance | User feels trapped | Add drag handle, close button, tap-outside |
| Long forms in basic dialog | Poor scrollability | Use full-screen dialog or page |
| Standard sheet for critical | User might miss it | Use modal variant or dialog |
| Fixed height with keyboard | Input fields obscured | Use `isScrollControlled` + `viewInsets` |

---

### 📚 Material Design 3 Resources

- **Dialogs**: [m3.material.io/components/dialogs](https://m3.material.io/components/dialogs/guidelines)
- **Bottom Sheets**: [m3.material.io/components/bottom-sheets](https://m3.material.io/components/bottom-sheets/guidelines)
- **Side Sheets**: [m3.material.io/components/side-sheets](https://m3.material.io/components/side-sheets/guidelines)
- **Flutter Docs**: [docs.flutter.dev/ui/widgets/material](https://docs.flutter.dev/ui/widgets/material)

---

### 🎬 Final Recommendations

1. **Start Conservative**: When unsure, default to less interruptive options
2. **Test on Real Devices**: Emulators don't capture touch gestures accurately
3. **Follow Platform Conventions**: iOS and Android have different sheet expectations
4. **Measure User Behavior**: Track dismissal rates and completion rates
5. **Iterate Based on Feedback**: UX is contextual—adapt to your users' needs

**Remember**: The best overlay component is often no overlay at all. Consider if a SnackBar, inline message, or dedicated page might serve users better.

---

**Speaker Notes**: Wrap up by emphasizing that these are guidelines, not rules. Every app is unique—the framework helps make informed decisions, but user testing should validate choices. Encourage questions about specific use cases, and remind the audience that Material Design 3 is continually evolving. Check for updates quarterly.