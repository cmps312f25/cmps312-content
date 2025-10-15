## What is ShellRoute?

**ShellRoute** is a special route in `go_router` that wraps multiple child routes with a common UI shell (like a persistent bottom navigation bar).

## Implementation Pattern

**Option A: Flexible Per-Screen Customization**

```
┌─────────────────────────────────┐
│  AppBar (from individual screen)│ ← Each screen provides its own
├─────────────────────────────────┤
│                                 │
│   SCREEN CONTENT                │ ← HomeScreen, FruitsScreen, etc.
│   (from individual screen)      │
│                                 │
├─────────────────────────────────┤
│  Bottom Nav (from ShellRoute)   │ ← ONLY this is from ShellRoute
└─────────────────────────────────┘
```

### ✅ **Advantages:**
1. **Flexible Customization** - Each screen can have different AppBar styles/colors
2. **Clear Separation** - Each screen is self-contained and independent
3. **Easier Testing** - Screens can be tested individually
4. **No Duplication Issues** - No double Scaffold problem


## How It Works

### ShellRoute (app_router.dart)
```dart
ShellRoute(
  builder: (context, state, child) {
    return Scaffold(
      body: child,  // ← Individual screen with its own Scaffold
      bottomNavigationBar: BottomNavBar(...),  // ← ONLY bottom nav
    );
  },
  routes: [
    GoRoute(path: '/', pageBuilder: (context, state) => 
      const NoTransitionPage(child: HomeScreen())),
    // ... other routes
  ],
)
```
## Best Practices

### ✅ DO:
- Use ShellRoute ONLY for bottom navigation bar
- Let each screen provide its own AppBar and Drawer
- Put detail screens OUTSIDE ShellRoute


## Alternative Approach

**Option B: ShellRoute Provides Everything**
- ShellRoute provides AppBar + Drawer + Bottom Nav
- Individual screens only provide body content
- Less flexible but more centralized
- Good when all screens have identical AppBar styling and content

## When to Use ShellRoute

✅ Use when you have:
- Bottom navigation bar that persists across screens
- Tab bar that stays visible
- Any persistent UI at the bottom

❌ Don't use for:
- Detail screens (put outside ShellRoute)
- Completely different layouts
