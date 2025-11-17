# Authentication System

## Overview
This application uses Supabase Authentication with email/password authentication. The system includes:
- User registration with full name
- Email/password sign-in
- Session management
- Protected routes
- User-specific data with RLS policies

## Architecture

### 1. Repository Layer
**File:** `lib/features/auth/repositories/auth_repository.dart`

Provides authentication business logic:
```dart
class AuthRepository {
  Future<void> signUp(String email, String password, String fullName)
  Future<void> signIn(String email, String password)
  Future<void> signOut()
  Future<void> resetPassword(String email)
  Future<void> updateUserMetadata(Map<String, dynamic> data)
  
  User? get currentUser
  bool get isAuthenticated
  String? get userFullName
  String? get userEmail
  Stream<User?> get authStateChanges
}
```

### 2. State Management
**File:** `lib/features/auth/providers/auth_provider.dart`

Riverpod providers for reactive auth state:
```dart
// Repository instance
final authRepositoryProvider = Provider<AuthRepository>

// Current user stream
final currentUserProvider = StreamProvider<User?>

// Authentication status stream
final isAuthenticatedProvider = StreamProvider<bool>
```

### 3. UI Screens

#### Sign In Screen
**File:** `lib/features/auth/screens/signin_screen.dart`

Features:
- Email and password fields with validation
- Password visibility toggle
- Loading state during authentication
- Error handling with SnackBar
- "Create Account" navigation to signup
- "Forgot Password" placeholder

#### Sign Up Screen
**File:** `lib/features/auth/screens/signup_screen.dart`

Features:
- Full name, email, password, and confirm password fields
- Password matching validation
- Email format validation
- Loading state during registration
- Error handling with SnackBar
- "Already have account" navigation to signin

### 4. Routing
**File:** `lib/app/router.dart`

Authentication-aware routing:
```dart
final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  
  return GoRouter(
    redirect: (context, state) {
      // Redirect to /signin if not authenticated
      // Redirect to /todo if authenticated and on auth route
    },
    routes: [
      // Public routes: /signin, /signup
      // Protected routes: /todo, /pets (wrapped in ShellRoute)
    ],
  );
});
```

### 5. User Interface Integration
**File:** `lib/app/main_scaffold.dart`

Features:
- AppBar with user's full name
- Sign out button with confirmation dialog
- Bottom navigation bar
- Automatic redirect to signin after sign out

## User Flow

### Registration Flow
1. User navigates to Sign In screen (default for unauthenticated users)
2. User clicks "Create Account"
3. User fills in full name, email, password, and confirms password
4. System validates inputs (email format, password match)
5. System creates user account with `full_name` metadata
6. System automatically signs in the user
7. Router redirects to `/todo` (home screen)

### Sign In Flow
1. User enters email and password
2. System validates credentials with Supabase
3. On success, router redirects to `/todo`
4. On failure, error message is displayed

### Sign Out Flow
1. User clicks sign out button in AppBar
2. Confirmation dialog appears
3. On confirmation, system signs out
4. Router redirects to `/signin`

## Database Integration

### User Metadata
User's full name is stored in Supabase auth metadata:
```sql
auth.users {
  id: UUID,
  email: TEXT,
  raw_user_meta_data: JSONB {
    full_name: TEXT
  }
}
```

### User-Linked Data
Todos are linked to authenticated users:
```sql
CREATE TABLE todos (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  status VARCHAR(20) NOT NULL,
  priority VARCHAR(20) NOT NULL,
  due_date DATE,
  created_by UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

### Row Level Security (RLS)
RLS policies ensure users can only access their own data:
```sql
-- Enable RLS
ALTER TABLE todos ENABLE ROW LEVEL SECURITY;

-- Users can read their own todos
CREATE POLICY "Users can view their own todos"
  ON todos FOR SELECT
  USING (auth.uid() = created_by);

-- Users can insert their own todos
CREATE POLICY "Users can insert their own todos"
  ON todos FOR INSERT
  WITH CHECK (auth.uid() = created_by);

-- Users can update their own todos
CREATE POLICY "Users can update their own todos"
  ON todos FOR UPDATE
  USING (auth.uid() = created_by);

-- Users can delete their own todos
CREATE POLICY "Users can delete their own todos"
  ON todos FOR DELETE
  USING (auth.uid() = created_by);
```

## Usage Examples

### Check Authentication Status
```dart
// In a widget
final isAuthenticated = ref.watch(isAuthenticatedProvider);

if (isAuthenticated.value == true) {
  // User is authenticated
}
```

### Get Current User Info
```dart
final authRepository = ref.read(authRepositoryProvider);
final userName = authRepository.userFullName;
final userEmail = authRepository.userEmail;
```

### Sign Out Programmatically
```dart
final authRepository = ref.read(authRepositoryProvider);
await authRepository.signOut();
```

### Create Todo with User Link
```dart
final authRepository = ref.read(authRepositoryProvider);
final userId = authRepository.currentUser?.id;

final todo = Todo(
  title: 'My Todo',
  description: 'Description',
  status: 'pending',
  priority: 'medium',
  createdBy: userId, // Links todo to authenticated user
);

await todoRepository.addTodo(todo);
```

## Security Considerations

1. **Password Requirements:** Currently basic validation. Consider adding:
   - Minimum length requirement (8+ characters)
   - Complexity requirements (uppercase, lowercase, numbers, symbols)
   - Password strength indicator

2. **Email Verification:** Supabase supports email verification. Enable in Supabase dashboard:
   - Settings → Authentication → Email Templates
   - Enable "Confirm email" template

3. **Rate Limiting:** Supabase provides built-in rate limiting for authentication endpoints

4. **Session Management:** Sessions are automatically managed by Supabase:
   - Default session lifetime: 1 week
   - Automatic token refresh
   - Secure token storage

## Future Enhancements

### Forgot Password Implementation
```dart
// In AuthRepository (already exists)
Future<void> resetPassword(String email) async {
  await _client.auth.resetPasswordForEmail(email);
}

// Add UI screen for password reset flow
```

### Social Authentication
```dart
// Add OAuth providers
await _client.auth.signInWithOAuth(Provider.google);
await _client.auth.signInWithOAuth(Provider.github);
```

### Profile Management
- Create profile screen to update user metadata
- Allow users to change email
- Allow users to update password
- Upload profile picture

### Multi-Factor Authentication
- Enable MFA in Supabase dashboard
- Add MFA setup flow in app
- Add MFA verification during sign-in

## Testing Checklist

- [ ] Sign up with new account
- [ ] Sign in with existing account
- [ ] Sign out
- [ ] Invalid email format error
- [ ] Password mismatch error on signup
- [ ] Wrong password error on signin
- [ ] Protected routes redirect to signin when not authenticated
- [ ] Auth routes redirect to home when authenticated
- [ ] User name displays correctly in AppBar
- [ ] Sign out confirmation dialog works
- [ ] Todos are filtered by authenticated user (RLS)
- [ ] Creating todo automatically sets created_by

## Troubleshooting

### "Invalid JWT" Error
- Check Supabase URL and anon key in `config/supabase_config.dart`
- Ensure Supabase project is active

### Sign In Not Working
- Check user exists in Supabase dashboard
- Verify email confirmation if enabled
- Check Supabase logs for authentication errors

### RLS Policy Issues
- Verify policies are enabled: `ALTER TABLE todos ENABLE ROW LEVEL SECURITY`
- Check policy conditions match your use case
- Test with Supabase SQL editor using `auth.uid()` function

### Router Not Redirecting
- Check `isAuthenticatedProvider` is returning correct value
- Verify `authStateChanges` stream is emitting events
- Add debug prints in router redirect function
