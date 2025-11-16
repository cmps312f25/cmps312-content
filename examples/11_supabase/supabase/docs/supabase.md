## 🚀 Supabase for Flutter – Slide Deck Guide

Speaker notes: This deck is designed to drop into PowerPoint/Keynote. Each H2 is a slide; H3 are sub-slides. Code targets supabase_flutter 2.x and Material 3. Tested patterns align with official Supabase docs and modern Flutter best practices.

---

## ✨ Divider • What is Supabase?

Supabase is an open-source Firebase alternative built on PostgreSQL with batteries included: database, authentication, storage, and realtime APIs.

- 🗄️ PostgreSQL database with Row Level Security (RLS)
- 🔐 Authentication and authorization
- ☁️ File storage (buckets, public/signed URLs)
- 🔔 Realtime (Postgres changes, presence, broadcasts)
- 📱 First-class Flutter/Dart SDKs

Notes (speaker): Emphasize that Supabase equals “Postgres + platform services.” You get SQL power, migrations, policies, and the ability to scale or self-host.

---

## 🧩 Setup & Initialization

### Overview
- Install supabase_flutter and optional pickers
- Initialize once before runApp
- Provide URL and anon key via Dart defines (avoid hardcoding secrets)

### Implementation

```yaml
# pubspec.yaml (SDKs used in this project)
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.10.3
  image_picker: ^1.1.2   # for camera/gallery
  file_picker: ^8.0.0    # optional: web/desktop files
  flutter_riverpod: ^3.0.3
  go_router: ^16.3.0
```

```dart
// main.dart (Material 3, Supabase init)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  final supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw StateError('Missing SUPABASE_URL or SUPABASE_ANON_KEY');
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Supabase Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      debugShowCheckedModeBanner: false,
      routerConfig: router, // your GoRouter
    );
  }
}
```

```powershell
# Run (Windows PowerShell)
flutter run -d chrome `
  --dart-define=SUPABASE_URL=https://<project-id>.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=<public-anon-key>
```

Best Practices
- Use Dart defines or a secure config manager. Don’t hardcode keys in source.
- Initialize Supabase once only. Access via Supabase.instance.client.
- For production, prefer service role keys on server-side only (never in apps).

Notes (speaker): Mention environments (dev/stage/prod) and CI variables.

---

## 🛢️ Divider • Supabase Database

Description: A fully managed Postgres with SQL, views, triggers, policies, functions, and extensions.

### Overview
- Schema-first: design tables in SQL or the Supabase dashboard
- Security via Row Level Security (RLS) + policies
- Migrations for versioning

### Implementation (Skeleton)

```sql
-- Example table: todos
create table if not exists public.todos (
  id uuid primary key default gen_random_uuid(),
  description text not null,
  type text not null check (type in ('personal','work','family')),
  completed boolean not null default false,
  created_at timestamptz not null default now(),
  user_id uuid references auth.users(id)
);

-- Enable RLS and add a basic policy
alter table public.todos enable row level security;
create policy "read own" on public.todos
  for select using (auth.uid() = user_id);
create policy "modify own" on public.todos
  for all using (auth.uid() = user_id);
```

Best Practices
- Design with explicit constraints and enums (or check constraints) for data quality
- Always enable RLS; craft least-privilege policies
- Use views/functions for complex reads and aggregations

Notes (speaker): Stress testing policies early; avoid broad ‘true’ policies.

---

## ✍️ Database CRUD Operations

### Overview
- Use Postgrest-style queries from the Flutter SDK
- Keep queries in repositories; keep widgets thin

### Implementation (Flutter)

```dart
final client = Supabase.instance.client;

// CREATE
Future<void> addTodo(Todo todo) async {
  await client.from('todos').insert(todo.toJson());
}

// READ (list)
Future<List<Todo>> getTodos() async {
  final data = await client.from('todos').select().order('created_at', ascending: false);
  return (data as List).map((j) => Todo.fromJson(j)).toList();
}

// READ (single)
Future<Todo?> getTodoById(String id) async {
  final json = await client.from('todos').select().eq('id', id).maybeSingle();
  return json == null ? null : Todo.fromJson(json);
}

// UPDATE
Future<void> updateTodo(Todo todo) async {
  await client.from('todos').update(todo.toJson()).eq('id', todo.id);
}

// DELETE
Future<void> deleteTodo(String id) async {
  await client.from('todos').delete().eq('id', id);
}

// COUNT
Future<int> getTodosCount() async {
  final res = await client.from('todos').select().count(CountOption.exact);
  return res.count; // supabase_flutter 2.x
}
```

Best Practices
- Centralize data access in repositories; inject SupabaseClient
- Paginate with range() for large lists
- Use select() projections to limit payload
- Always handle errors (try/catch) and show user-friendly messages

Notes (speaker): Mention retries/backoff for flaky networks and offline UI.

---

## 🔔 Listen to Database Realtime Updates

### Overview
- Two common approaches:
  1) Postgrest Stream: `.from('table').stream(primaryKey: ['id'])`
  2) Realtime Channels: `client.channel(...).onPostgresChanges(...)`

### Implementation (Stream for simple lists)

```dart
Stream<List<Todo>> observeTodos() {
  final client = Supabase.instance.client;
  return client
    .from('todos')
    .stream(primaryKey: ['id'])
    .order('created_at', ascending: false)
    .map((rows) => rows.map(Todo.fromJson).toList());
}
```

### Implementation (Realtime Channel – fine-grained)

```dart
final channel = Supabase.instance.client.channel('public:todos');

RealtimeChannelSubscription? sub = channel
  .onPostgresChanges(
    event: PostgresChangeEvent.insert,
    schema: 'public',
    table: 'todos',
    callback: (payload) {
      // payload.newRecord / payload.oldRecord
    },
  )
  .onPostgresChanges(
    event: PostgresChangeEvent.update,
    schema: 'public',
    table: 'todos',
    callback: (payload) {},
  )
  .subscribe();

// Later: await channel.unsubscribe();
```

Best Practices
- Prefer stream() for lists; Channels for targeted events or multi-table logic
- Debounce UI updates when batching changes
- Guard with auth checks; RLS applies to realtime too

Notes (speaker): Demo toggling a todo and seeing UI auto-refresh.

---

## 🗂️ Divider • File Storage

Description: S3-like buckets with public/private access and signed URLs.

### Overview
- Create buckets in the Supabase dashboard
- Store images, documents, or media; serve via public or signed URLs
- Secure with RLS-like bucket policies

### Implementation

```dart
final storage = Supabase.instance.client.storage;

// Upload bytes (e.g., from picker)
Future<String> uploadAvatar(Uint8List bytes, String userId) async {
  final path = 'avatars/$userId-${DateTime.now().millisecondsSinceEpoch}.png';
  await storage.from('avatars').uploadBinary(
    path,
    bytes,
    fileOptions: const FileOptions(contentType: 'image/png'),
  );
  // Return public URL (if bucket is public) or create a signed URL
  return storage.from('avatars').getPublicUrl(path);
}

// Signed URL (private bucket)
Future<Uri> getSignedUrl(String path, {Duration ttl = const Duration(minutes: 5)}) async {
  final url = await storage.from('avatars').createSignedUrl(path, ttl.inSeconds);
  return Uri.parse(url);
}
```

Best Practices
- Use hashed/UUID file names; avoid collisions
- Keep buckets private and use signed URLs where possible
- Clean up old files when entities are deleted

Notes (speaker): Mention CDN caching and image resizing (Edge Functions/Transformations).

---

## 📸 Access Image Gallery & Camera

### Overview
- Use image_picker for mobile camera/gallery
- On web/desktop, file_picker is often more ergonomic
- Convert to bytes, upload to Storage; persist path in DB

### Implementation (Flutter Material 3)

```dart
import 'dart:Uint8List';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarUploader extends StatefulWidget {
  const AvatarUploader({super.key});
  @override
  State<AvatarUploader> createState() => _AvatarUploaderState();
}

class _AvatarUploaderState extends State<AvatarUploader> {
  final _picker = ImagePicker();
  Uint8List? _preview;
  bool _busy = false;

  Future<void> _pickAndUpload() async {
    try {
      setState(() => _busy = true);
      final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (file == null) return;
      final bytes = await file.readAsBytes();

      final url = await uploadAvatar(bytes, 'currentUserId'); // call repository method
      setState(() => _preview = bytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploaded! $url')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_preview != null)
          ClipOval(child: Image.memory(_preview!, width: 96, height: 96, fit: BoxFit.cover)),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _busy ? null : _pickAndUpload,
          icon: const Icon(Icons.upload),
          label: const Text('Upload Avatar'),
        ),
      ],
    );
  }
}
```

Best Practices
- Respect platform storage permissions and privacy
- Compress images; consider WebP/AVIF for web
- Store only the storage path in DB; render via public/signed URL

Notes (speaker): On iOS, add NSPhotoLibraryUsageDescription/NSCameraUsageDescription.

---

## 🔐 Divider • Authentication

Description: Email/password, OTP/magic links, and OAuth providers (Google, Apple, etc.).

### Overview
- Session-based auth with refresh tokens
- Auth state stream for UI guards
- Policies use auth.uid() to restrict access

### Implementation

```dart
final auth = Supabase.instance.client.auth;

// Sign up
Future<void> signUp(String email, String password) async {
  await auth.signUp(email: email, password: password);
}

// Sign in
Future<void> signIn(String email, String password) async {
  await auth.signInWithPassword(email: email, password: password);
}

// Sign out
Future<void> signOut() async {
  await auth.signOut();
}

// Listen to auth state
void listenAuth() {
  auth.onAuthStateChange.listen((event) {
    final session = event.session;
    // navigate or rebuild providers
  });
}
```

Auth Guard (GoRouter + Riverpod skeleton)

```dart
final authStateProvider = StreamProvider((ref) {
  return Supabase.instance.client.auth.onAuthStateChange
    .map((e) => e.session);
});

final authGuard = GoRoute(
  path: '/account',
  builder: (context, state) => const AccountScreen(),
  redirect: (context, state) {
    final session = context.read(authStateProvider).maybeWhen(
      data: (s) => s,
      orElse: () => null,
    );
    return session == null ? '/signin' : null;
  },
);
```

Best Practices
- Never store service role keys in the client
- Use SSO where possible; prefer passwordless for UX
- Implement token refresh-aware network layers
- Keep auth UI accessible and localize error messages

Notes (speaker): Highlight policies tied to auth.uid() and testing RLS with SQL.

---

## 🧭 Architecture & Patterns

- Repositories wrap Supabase client (clean separation from UI)
- Riverpod providers expose repositories and view models
- GoRouter for navigation; use guards tied to auth state
- Keep widgets presentational; avoid direct DB calls from UI

```dart
final supabaseClientProvider = Provider((ref) => Supabase.instance.client);

final todoRepositoryProvider = Provider((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TodoRepository(client);
});
```

---

## ✅ Best Practices & Recommendations

1) Security
- Enable RLS on every table; write least-privilege policies
- Use signed URLs for private assets; short TTLs for sensitive files

2) Performance
- Use projections and pagination; avoid select('*') in production
- Prefer streams for live lists; batch UI updates

3) DX & Ops
- Keep migration SQL in version control
- Use Edge Functions for server-side logic (secrets, webhooks)
- Monitor quotas (realtime connections, storage egress)

4) Testing
- Unit test repositories with mocked Supabase client
- Add integration tests hitting a staging Supabase project

---

## 📚 References (Authoritative)

- Supabase Flutter Docs: https://supabase.com/docs/guides/getting-started/quickstarts/flutter
- Realtime: https://supabase.com/docs/guides/realtime
- Storage: https://supabase.com/docs/guides/storage
- Auth: https://supabase.com/docs/guides/auth
- RLS Policies: https://supabase.com/docs/guides/auth/row-level-security

Notes (speaker): Encourage reading policy recipes and the table editor’s policy debugger.
