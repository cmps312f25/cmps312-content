# 📢 Feedback & Status Indicators

---

## 📢 Feedback & Status Indicators

**Widgets for user feedback and progress**

> ![📊](https://img.icons8.com/color/48/000000/feedback.png)

Flutter provides comprehensive widgets for communicating app state, progress, and feedback to users. These widgets ensure users understand what's happening and receive confirmation of their actions.

---

# 🧱 Progress Indicators

## 1️⃣ CircularProgressIndicator
### Overview
- **Purpose:** Display circular loading indicator for indeterminate or determinate progress.
- **Key Properties:** `value` (null for indeterminate), `strokeWidth`, `backgroundColor`, `color`, `semanticsLabel`.
- **Events:** None.
- **Usage Scenarios:** Loading states, async operations, download progress, tasks in progress.

#### Speaker Notes
- CircularProgressIndicator is the standard for showing loading and progress states.

---

### 2️⃣ Example
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // Indeterminate progress
    Text('Loading...', style: TextStyle(fontSize: 18)),
    SizedBox(height: 16),
    CircularProgressIndicator(
      color: Colors.blue,
      strokeWidth: 4,
    ),
    
    SizedBox(height: 48),
    
    // Determinate progress
    Text('Download Progress', style: TextStyle(fontSize: 18)),
    SizedBox(height: 16),
    Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: 0.65,
            strokeWidth: 8,
            backgroundColor: Colors.grey.shade300,
            color: Colors.green,
          ),
        ),
        Text('65%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    ),
    
    SizedBox(height: 48),
    
    // Custom styled progress
    Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircularProgressIndicator(
            color: Colors.blue,
            strokeWidth: 6,
          ),
          SizedBox(height: 16),
          Text('Processing your request...', style: TextStyle(color: Colors.blue.shade700)),
        ],
      ),
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use `value: null` for unknown duration (indeterminate).
- Use `value: 0.0-1.0` for known progress (determinate).
- Provide meaningful `semanticsLabel` for accessibility.
- Match colors to theme or context.
- Show with overlay for blocking operations.
- Combine with text for clarity.
- Use appropriate size for context (default is 36x36).

#### Speaker Notes
- Always provide feedback for operations over 0.5 seconds. CircularProgressIndicator is familiar and expected.

---

## 1️⃣ LinearProgressIndicator
### Overview
- **Purpose:** Display horizontal bar for linear progress.
- **Key Properties:** `value` (null for indeterminate), `minHeight`, `backgroundColor`, `color`, `semanticsLabel`.
- **Events:** None.
- **Usage Scenarios:** File uploads, downloads, multi-step processes, page loading.

#### Speaker Notes
- LinearProgressIndicator shows progress in a horizontal bar format.

---

### 2️⃣ Example
```dart
Padding(
  padding: EdgeInsets.all(24),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Indeterminate progress
      Text('Loading...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      SizedBox(height: 12),
      LinearProgressIndicator(
        color: Colors.blue,
        backgroundColor: Colors.grey.shade300,
      ),
      
      SizedBox(height: 48),
      
      // Determinate progress with percentage
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Upload Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text('45%', style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
      SizedBox(height: 12),
      LinearProgressIndicator(
        value: 0.45,
        minHeight: 8,
        backgroundColor: Colors.grey.shade300,
        color: Colors.blue,
      ),
      
      SizedBox(height: 48),
      
      // Multi-step progress
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Step 2 of 5', style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text('40%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.4,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
            ),
          ),
        ],
      ),
      
      SizedBox(height: 48),
      
      // Styled in card
      Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.download, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Downloading file.pdf', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              SizedBox(height: 12),
              LinearProgressIndicator(
                value: 0.75,
                minHeight: 6,
                backgroundColor: Colors.blue.shade50,
                color: Colors.blue,
              ),
              SizedBox(height: 8),
              Text('7.5 MB of 10 MB', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    ],
  ),
)
```

---

### 3️⃣ Best Practices
- Use for horizontal space contexts.
- Show progress percentage with text.
- Use `minHeight` for custom thickness.
- Round corners with `ClipRRect` for polish.
- Ideal for multi-step processes.
- Update frequently for smooth progress.
- Provide context with labels.

#### Speaker Notes
- LinearProgressIndicator is better for horizontal layouts and shows progress direction clearly.

---

# 🧱 SnackBars & Toasts

## 1️⃣ SnackBar
### Overview
- **Purpose:** Display brief message at bottom of screen with optional action.
- **Key Properties:** `content`, `action`, `duration`, `backgroundColor`, `behavior`, `margin`, `shape`.
- **Events:** Action callback.
- **Usage Scenarios:** Success messages, undo actions, brief feedback, errors.

#### Speaker Notes
- SnackBar provides lightweight, non-intrusive feedback for user actions.

---

### 2️⃣ Example
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item added to cart'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View Cart',
              textColor: Colors.white,
              onPressed: () {
                print('View cart tapped');
              },
            ),
          ),
        );
      },
      child: Text('Simple SnackBar'),
    ),
    
    SizedBox(height: 16),
    
    ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text('Changes saved successfully!')),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Text('Success SnackBar'),
    ),
    
    SizedBox(height: 16),
    
    ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text('Failed to upload file. Please try again.')),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                print('Retry upload');
              },
            ),
            duration: Duration(seconds: 4),
          ),
        );
      },
      child: Text('Error SnackBar'),
    ),
    
    SizedBox(height: 16),
    
    ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Message deleted'),
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.yellow,
              onPressed: () {
                print('Undo delete');
              },
            ),
            duration: Duration(seconds: 5),
          ),
        );
      },
      child: Text('Undo SnackBar'),
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use `ScaffoldMessenger.of(context)` to show SnackBars.
- Keep messages brief and actionable.
- Use `SnackBarBehavior.floating` for modern look.
- Provide undo actions when appropriate.
- Use color coding (green=success, red=error, blue=info).
- Set appropriate duration (2-4 seconds).
- Add icons for context.
- Dismiss previous SnackBars if showing new ones.

#### Speaker Notes
- SnackBar is perfect for brief, non-critical feedback. Use actions for undo or quick navigation.

---

# 🧱 Tooltips & Hints

## 1️⃣ Tooltip
### Overview
- **Purpose:** Display helpful text on long press or hover.
- **Key Properties:** `message`, `child`, `preferBelow`, `verticalOffset`, `decoration`, `textStyle`, `waitDuration`, `showDuration`.
- **Events:** Automatic on hover/long press.
- **Usage Scenarios:** Icon explanations, accessibility, helper text, feature discovery.

#### Speaker Notes
- Tooltips enhance usability and accessibility by explaining UI elements.

---

### 2️⃣ Example
```dart
Padding(
  padding: EdgeInsets.all(24),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Basic tooltip
      Tooltip(
        message: 'Add to favorites',
        child: IconButton(
          icon: Icon(Icons.favorite_border, size: 32),
          onPressed: () {},
        ),
      ),
      
      SizedBox(height: 32),
      
      // Styled tooltip
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Tooltip(
            message: 'Search for music',
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: TextStyle(color: Colors.white, fontSize: 14),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: IconButton(
              icon: Icon(Icons.search, size: 32, color: Colors.blue),
              onPressed: () {},
            ),
          ),
          Tooltip(
            message: 'Share with friends',
            preferBelow: false,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            padding: EdgeInsets.all(12),
            child: IconButton(
              icon: Icon(Icons.share, size: 32, color: Colors.purple),
              onPressed: () {},
            ),
          ),
          Tooltip(
            message: 'Download for offline',
            waitDuration: Duration(milliseconds: 500),
            child: IconButton(
              icon: Icon(Icons.download, size: 32, color: Colors.green),
              onPressed: () {},
            ),
          ),
        ],
      ),
      
      SizedBox(height: 32),
      
      // Text with tooltip
      Tooltip(
        message: 'This is a premium feature available to subscribers only',
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.amber),
            SizedBox(width: 8),
            Text('Premium Feature',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(width: 4),
            Icon(Icons.info_outline, size: 18, color: Colors.grey),
          ],
        ),
      ),
    ],
  ),
)
```

---

### 3️⃣ Best Practices
- Use for all icon-only buttons.
- Keep messages concise and helpful.
- Essential for accessibility (screen readers).
- Customize appearance to match theme.
- Use `preferBelow` to control position.
- Set `waitDuration` for hover delay.
- Don't use for obvious actions.
- Provide context, not just labels.

#### Speaker Notes
- Tooltips are critical for accessibility and help users discover features. Always use them for icon buttons.

---

# 🧱 Dividers & Separators

## 1️⃣ Divider
### Overview
- **Purpose:** Horizontal line to separate content sections.
- **Key Properties:** `height`, `thickness`, `color`, `indent`, `endIndent`.
- **Events:** None.
- **Usage Scenarios:** List separation, section breaks, visual grouping.

#### Speaker Notes
- Divider creates visual separation between content sections.

---

### 2️⃣ Example
```dart
Column(
  children: [
    ListTile(
      leading: Icon(Icons.home),
      title: Text('Home'),
      onTap: () {},
    ),
    Divider(),
    ListTile(
      leading: Icon(Icons.settings),
      title: Text('Settings'),
      onTap: () {},
    ),
    Divider(thickness: 2, color: Colors.grey),
    ListTile(
      leading: Icon(Icons.info),
      title: Text('About'),
      onTap: () {},
    ),
    
    SizedBox(height: 32),
    
    // Styled dividers
    Divider(
      height: 20,
      thickness: 1,
      indent: 20,
      endIndent: 20,
      color: Colors.blue.shade300,
    ),
    
    Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 2)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('OR', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Divider(thickness: 2)),
        ],
      ),
    ),
    
    // Card with divider
    Card(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Section 1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Divider(height: 1, thickness: 1),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Section 2', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use to separate content sections.
- Set `thickness` for prominence.
- Use `indent` and `endIndent` for alignment.
- Match color to theme.
- Use sparingly to avoid clutter.
- Combine with text for section headers.

#### Speaker Notes
- Divider creates clear visual hierarchy and grouping.

---

## 1️⃣ VerticalDivider
### Overview
- **Purpose:** Vertical line to separate content columns.
- **Key Properties:** `width`, `thickness`, `color`, `indent`, `endIndent`.
- **Events:** None.
- **Usage Scenarios:** Split views, toolbar sections, side-by-side content.

#### Speaker Notes
- VerticalDivider separates columns and vertical sections.

---

### 2️⃣ Example
```dart
Container(
  height: 200,
  child: Row(
    children: [
      Expanded(
        child: Container(
          color: Colors.blue.shade50,
          child: Center(child: Text('Left Panel')),
        ),
      ),
      VerticalDivider(
        width: 1,
        thickness: 1,
        color: Colors.grey,
      ),
      Expanded(
        child: Container(
          color: Colors.green.shade50,
          child: Center(child: Text('Right Panel')),
        ),
      ),
    ],
  ),
)

// Toolbar example
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    IconButton(icon: Icon(Icons.format_bold), onPressed: () {}),
    IconButton(icon: Icon(Icons.format_italic), onPressed: () {}),
    VerticalDivider(width: 20, thickness: 2, indent: 8, endIndent: 8),
    IconButton(icon: Icon(Icons.format_align_left), onPressed: () {}),
    IconButton(icon: Icon(Icons.format_align_center), onPressed: () {}),
    VerticalDivider(width: 20, thickness: 2, indent: 8, endIndent: 8),
    IconButton(icon: Icon(Icons.link), onPressed: () {}),
  ],
)
```

---

### 3️⃣ Best Practices
- Use in Row widgets for vertical separation.
- Must have bounded height (use in Container or set indent/endIndent).
- Ideal for split views and toolbars.
- Match styling to horizontal Divider.

#### Speaker Notes
- VerticalDivider is perfect for separating toolbar sections and side-by-side content.

---

# 📊 Summary & Key Takeaways

---

## Final Summary
- Flutter provides comprehensive feedback widgets for all user interaction needs.
- Progress indicators show loading and progress states (circular for general, linear for horizontal contexts).
- SnackBar provides lightweight, non-intrusive feedback with optional actions.
- Tooltips enhance accessibility and explain UI elements.
- Dividers create visual separation and hierarchy.

## Key Takeaway
- Always provide feedback for user actions and system states.
- Choose indicators based on context:
  - **CircularProgressIndicator:** General loading, compact spaces
  - **LinearProgressIndicator:** Horizontal contexts, clear progress direction
  - **SnackBar:** Brief success/error messages with optional actions
  - **Tooltip:** Icon explanations and accessibility
  - **Divider:** Content separation
- Feedback improves perceived performance and user confidence.

## Optimization Principles
- Show progress indicators for operations over 0.5 seconds.
- Use determinate progress when duration is known.
- Keep SnackBar messages brief (under 20 words).
- Provide undo actions in SnackBars when appropriate.
- Use tooltips for all icon-only buttons for accessibility.
- Color-code feedback (green=success, red=error, blue=info).
- Update progress smoothly (avoid jumps).
- Dismiss SnackBars before showing new ones.
- Use appropriate duration for SnackBars (2-4 seconds).
- Provide semantic labels for screen readers.

---

> ![🎯](https://img.icons8.com/color/48/000000/goal.png) **Clear feedback and status indicators build user trust and confidence in your app!**
