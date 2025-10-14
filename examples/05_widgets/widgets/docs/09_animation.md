# ✨ Animation

---

## ✨ Animation

**Widgets for transitions and effects**

> ![🎬](https://img.icons8.com/color/48/000000/animation.png)

Flutter provides powerful animation widgets that bring UIs to life. From simple implicit animations to complex explicit transitions, these widgets enable smooth, performant motion that enhances user experience.

---

# 🧱 Implicit Animations

## 1️⃣ AnimatedContainer
### Overview
- **Purpose:** Automatically animate Container property changes.
- **Key Properties:** `duration`, `curve`, all Container properties (width, height, color, decoration, etc.).
- **Events:** None (automatic).
- **Usage Scenarios:** Smooth transitions, interactive effects, state changes.

#### Speaker Notes
- AnimatedContainer is the easiest way to animate UI changes with automatic interpolation.

---

### 2️⃣ Example
```dart
class AnimatedContainerExample extends StatefulWidget {
  @override
  _AnimatedContainerExampleState createState() => _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  bool _expanded = false;
  Color _color = Colors.blue;

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      _color = _expanded ? Colors.purple : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: _expanded ? 300 : 150,
          height: _expanded ? 300 : 150,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(_expanded ? 50 : 20),
            boxShadow: [
              BoxShadow(
                color: _color.withOpacity(0.5),
                blurRadius: _expanded ? 30 : 10,
                spreadRadius: _expanded ? 5 : 2,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              _expanded ? Icons.favorite : Icons.favorite_border,
              size: _expanded ? 80 : 40,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: _toggle,
          child: Text(_expanded ? 'Collapse' : 'Expand'),
        ),
      ],
    );
  }
}
```

---

### 3️⃣ Best Practices
- Use for simple property transitions.
- Keep duration between 200-500ms for responsiveness.
- Use appropriate curves (easeInOut for most cases).
- Animate multiple properties simultaneously.
- Avoid excessive animation for performance.
- **Recommended:** Use AnimatedContainer as the first choice for simple animations.

#### Speaker Notes
- AnimatedContainer handles interpolation automatically, making animation effortless.

---

## 1️⃣ AnimatedOpacity
### Overview
- **Purpose:** Smoothly animate opacity changes.
- **Key Properties:** `opacity`, `duration`, `curve`, `child`.
- **Events:** `onEnd` callback.
- **Usage Scenarios:** Fade in/out effects, loading states, visibility transitions.

#### Speaker Notes
- AnimatedOpacity provides smooth fade transitions for showing and hiding widgets.

---

### 2️⃣ Example
```dart
class AnimatedOpacityExample extends StatefulWidget {
  @override
  _AnimatedOpacityExampleState createState() => _AnimatedOpacityExampleState();
}

class _AnimatedOpacityExampleState extends State<AnimatedOpacityExample> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          onEnd: () {
            print('Animation completed');
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'Fade Effect',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _visible = !_visible;
            });
          },
          child: Text(_visible ? 'Fade Out' : 'Fade In'),
        ),
      ],
    );
  }
}
```

---

### 3️⃣ Best Practices
- Use for visibility transitions.
- Combine with other animations for rich effects.
- Use `onEnd` callback for sequential animations.
- Keep duration around 300-500ms.
- More efficient than AnimatedContainer for opacity-only changes.

#### Speaker Notes
- AnimatedOpacity is perfect for fade effects and is optimized for opacity changes.

---

## 1️⃣ AnimatedAlign
### Overview
- **Purpose:** Animate alignment changes within a container.
- **Key Properties:** `alignment`, `duration`, `curve`, `child`.
- **Events:** None.
- **Usage Scenarios:** Position transitions, sliding effects, layout changes.

#### Speaker Notes
- AnimatedAlign smoothly moves widgets to different positions within their parent.

---

### 2️⃣ Example
```dart
class AnimatedAlignExample extends StatefulWidget {
  @override
  _AnimatedAlignExampleState createState() => _AnimatedAlignExampleState();
}

class _AnimatedAlignExampleState extends State<AnimatedAlignExample> {
  AlignmentGeometry _alignment = Alignment.topLeft;

  final List<AlignmentGeometry> _alignments = [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomRight,
    Alignment.bottomLeft,
    Alignment.center,
  ];
  int _currentIndex = 0;

  void _moveToNext() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _alignments.length;
      _alignment = _alignments[_currentIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedAlign(
            alignment: _alignment,
            duration: Duration(milliseconds: 600),
            curve: Curves.easeInOutBack,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.circle, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: _moveToNext,
          child: Text('Move'),
        ),
      ],
    );
  }
}
```

---

### 3️⃣ Best Practices
- Use for position-based animations.
- Experiment with different curves for effects.
- Combine with scale or rotation for richer motion.
- Use for sliding panels and drawers.

#### Speaker Notes
- AnimatedAlign is great for moving elements smoothly within containers.

---

## 1️⃣ AnimatedCrossFade
### Overview
- **Purpose:** Animate transition between two widgets with cross-fade.
- **Key Properties:** `firstChild`, `secondChild`, `crossFadeState`, `duration`, `firstCurve`, `secondCurve`.
- **Events:** None.
- **Usage Scenarios:** Toggling between two views, state transitions, content switching.

#### Speaker Notes
- AnimatedCrossFade provides smooth transitions when switching between two widgets.

---

### 2️⃣ Example
```dart
class AnimatedCrossFadeExample extends StatefulWidget {
  @override
  _AnimatedCrossFadeExampleState createState() => _AnimatedCrossFadeExampleState();
}

class _AnimatedCrossFadeExampleState extends State<AnimatedCrossFadeExample> {
  bool _showFirst = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedCrossFade(
          firstChild: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.music_note, size: 80, color: Colors.white),
                SizedBox(height: 16),
                Text('Music Mode',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          secondChild: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.video_library, size: 80, color: Colors.white),
                SizedBox(height: 16),
                Text('Video Mode',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          crossFadeState: _showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 400),
          firstCurve: Curves.easeIn,
          secondCurve: Curves.easeOut,
        ),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showFirst = !_showFirst;
            });
          },
          child: Text('Toggle Mode'),
        ),
      ],
    );
  }
}
```

---

### 3️⃣ Best Practices
- Use for toggling between two distinct views.
- Ensure both children have similar sizes for smooth transitions.
- Customize curves for each child.
- Use for like/unlike, play/pause, or mode switches.

#### Speaker Notes
- AnimatedCrossFade is perfect for binary state transitions with smooth blending.

---

# 🧱 Explicit Animations

## 1️⃣ FadeTransition
### Overview
- **Purpose:** Explicit opacity animation with AnimationController.
- **Key Properties:** `opacity` (Animation), `child`.
- **Events:** Controller-based.
- **Usage Scenarios:** Custom timing, complex sequences, repeating animations.

#### Speaker Notes
- FadeTransition provides fine control over opacity animations with controllers.

---

### 2️⃣ Example
```dart
class FadeTransitionExample extends StatefulWidget {
  @override
  _FadeTransitionExampleState createState() => _FadeTransitionExampleState();
}

class _FadeTransitionExampleState extends State<FadeTransitionExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: _animation,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(Icons.star, size: 80, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _controller.forward(),
              child: Text('Fade In'),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => _controller.reverse(),
              child: Text('Fade Out'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

### 3️⃣ Best Practices
- Use AnimationController for precise control.
- Always dispose controllers to prevent memory leaks.
- Use `repeat()` for continuous animations.
- Combine with CurvedAnimation for easing.
- Use Tween for value interpolation.

#### Speaker Notes
- Explicit animations provide maximum control for complex animation sequences.

---

## 1️⃣ ScaleTransition
### Overview
- **Purpose:** Explicit scale animation with AnimationController.
- **Key Properties:** `scale` (Animation), `child`, `alignment`.
- **Events:** Controller-based.
- **Usage Scenarios:** Zoom effects, attention-grabbing, button feedback.

#### Speaker Notes
- ScaleTransition creates smooth zoom and scale effects.

---

### 2️⃣ Example
```dart
class ScaleTransitionExample extends StatefulWidget {
  @override
  _ScaleTransitionExampleState createState() => _ScaleTransitionExampleState();
}

class _ScaleTransitionExampleState extends State<ScaleTransitionExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: _animation,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(Icons.check, size: 100, color: Colors.white),
          ),
        ),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            _controller.reset();
            _controller.forward();
          },
          child: Text('Replay'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

### 3️⃣ Best Practices
- Use for attention-grabbing effects.
- Combine with other transitions for richer effects.
- Use curves like `elasticOut` for bouncy effects.
- Great for success states and celebrations.

#### Speaker Notes
- ScaleTransition is perfect for celebratory or emphasis animations.

---

## 1️⃣ SlideTransition
### Overview
- **Purpose:** Explicit position animation with AnimationController.
- **Key Properties:** `position` (Animation<Offset>), `child`.
- **Events:** Controller-based.
- **Usage Scenarios:** Sliding panels, page transitions, reveal effects.

#### Speaker Notes
- SlideTransition creates smooth sliding motion for widgets.

---

### 2️⃣ Example
```dart
class SlideTransitionExample extends StatefulWidget {
  @override
  _SlideTransitionExampleState createState() => _SlideTransitionExampleState();
}

class _SlideTransitionExampleState extends State<SlideTransitionExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRect(
          child: SlideTransition(
            position: _animation,
            child: Container(
              width: 280,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purple, Colors.pink]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(Icons.notifications_active, size: 60, color: Colors.white),
                  SizedBox(height: 12),
                  Text('New Notification',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('You have a new message',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _controller.forward(),
              child: Text('Slide In'),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => _controller.reverse(),
              child: Text('Slide Out'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

### 3️⃣ Best Practices
- Use Offset for direction control (x, y).
- Wrap in ClipRect to prevent overflow.
- Use for drawer and panel animations.
- Combine with other transitions for page transitions.

#### Speaker Notes
- SlideTransition is essential for drawer, panel, and page animations.

---

# 🧱 Hero Animations

## 1️⃣ Hero
### Overview
- **Purpose:** Animate widget between routes with shared element transition.
- **Key Properties:** `tag` (unique identifier), `child`.
- **Events:** Automatic on navigation.
- **Usage Scenarios:** Image zoom, detail transitions, gallery navigation.

#### Speaker Notes
- Hero creates cinematic transitions that maintain visual continuity across screens.

---

### 2️⃣ Example
```dart
// List Screen
class HeroListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {'id': 1, 'name': 'Album 1', 'color': Colors.blue},
    {'id': 2, 'name': 'Album 2', 'color': Colors.purple},
    {'id': 3, 'name': 'Album 3', 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Albums')),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HeroDetailScreen(item: item),
                ),
              );
            },
            child: Hero(
              tag: 'album-${item['id']}',
              child: Container(
                decoration: BoxDecoration(
                  color: item['color'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(Icons.album, size: 80, color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Detail Screen
class HeroDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const HeroDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(item['name'])),
      body: Center(
        child: Hero(
          tag: 'album-${item['id']}',
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: item['color'],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(Icons.album, size: 150, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

### 3️⃣ Best Practices
- Use unique, consistent tags across routes.
- Match widget types for smooth transitions.
- Great for image galleries and detail views.
- Keep hero widgets simple for performance.
- Use for maintaining visual continuity.

#### Speaker Notes
- Hero animations create professional, polished navigation experiences.

---

# 📊 Summary & Key Takeaways

---

## Final Summary
- Flutter offers two animation approaches: implicit (automatic) and explicit (controlled).
- Implicit animations (AnimatedContainer, AnimatedOpacity) are easiest for simple transitions.
- Explicit animations (FadeTransition, ScaleTransition) provide fine control with AnimationController.
- Hero animations create shared element transitions between routes.

## Key Takeaway
- Choose animation type based on complexity:
  - **Implicit:** Simple property changes (most common)
  - **Explicit:** Complex sequences, custom timing, repeating
  - **Hero:** Cross-screen element transitions
- Keep animations between 200-500ms for responsiveness.
- Use appropriate curves for natural motion.

## Optimization Principles
- Prefer implicit animations for simplicity.
- Always dispose AnimationControllers.
- Use const widgets where possible within animations.
- Keep animation duration under 500ms for responsiveness.
- Use `RepaintBoundary` for complex animations.
- Avoid animating heavy widgets.
- Test animations on real devices for performance.
- Use curves (easeInOut, elasticOut) for natural motion.

---

> ![🎯](https://img.icons8.com/color/48/000000/goal.png) **Thoughtful animations bring UIs to life and create delightful user experiences!**
