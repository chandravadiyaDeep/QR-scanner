import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

// Build-time configuration is injected by GitHub Actions; no private keys belong in Flutter.
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
const apiBaseUrl = String.fromEnvironment('API_BASE_URL');

bool get hasPublicConfig =>
    supabaseUrl.startsWith('https://') &&
    supabaseAnonKey.isNotEmpty &&
    apiBaseUrl.startsWith('https://');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Avoid crashing an installable preview build when deployment secrets are not configured.
  if (hasPublicConfig) {
    await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);
  }

  runApp(const QrDigitalMenuApp());
}

class QrDigitalMenuApp extends StatelessWidget {
  const QrDigitalMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Digital Menu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF07111F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3185FF),
          brightness: Brightness.dark,
          surface: const Color(0xFF101E31),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF12243A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: const Color(0xFF2678F3),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: hasPublicConfig ? const AuthGate() : const SetupRequiredScreen(),
    );
  }
}

class SetupRequiredScreen extends StatelessWidget {
  const SetupRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.qr_code_2_rounded, size: 64, color: Color(0xFF58A0FF)),
              SizedBox(height: 18),
              Text('QR Digital Menu', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text(
                'The Android preview is built. Supabase and API deployment configuration '
                'must be added to the secure build environment before sign-in testing.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    return StreamBuilder<AuthState>(
      stream: client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (client.auth.currentSession == null) {
          return const SignInScreen();
        }
        return const ShopHomeScreen();
      },
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isRegister = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final auth = Supabase.instance.client.auth;
      if (_isRegister) {
        await auth.signUp(email: _email.text.trim(), password: _password.text);
      } else {
        await auth.signInWithPassword(
          email: _email.text.trim(),
          password: _password.text,
        );
      }
    } on AuthException catch (error) {
      setState(() => _error = error.message);
    } catch (_) {
      setState(() => _error = 'Unable to connect. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.qr_code_2_rounded, size: 68, color: Color(0xFF58A0FF)),
                  const SizedBox(height: 18),
                  const Text(
                    'Your menu.\nOne simple scan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, height: 1.12, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Manage your shop menu and share it with every customer.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email address'),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _busy ? null : _submit,
                    child: _busy
                        ? const CircularProgressIndicator()
                        : Text(_isRegister ? 'Create account' : 'Sign in'),
                  ),
                  TextButton(
                    onPressed: _busy ? null : () => setState(() => _isRegister = !_isRegister),
                    child: Text(_isRegister
                        ? 'Already have an account? Sign in'
                        : 'New here? Create an account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShopHomeScreen extends StatefulWidget {
  const ShopHomeScreen({super.key});

  @override
  State<ShopHomeScreen> createState() => _ShopHomeScreenState();
}

class _ShopHomeScreenState extends State<ShopHomeScreen> {
  List<dynamic> _shops = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  Future<void> _loadShops() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final token = Supabase.instance.client.auth.currentSession!.accessToken;
      final response = await http.get(
        Uri.parse('${apiBaseUrl.replaceAll(RegExp(r'/+$'), '')}/api/v1/me'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception('Shop list request failed (${response.statusCode}).');
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      setState(() => _shops = (body['shops'] as List<dynamic>? ?? []));
    } catch (error) {
      setState(() => _error = error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _createShop() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const CreateShopDialog(),
    );
    if (result == null) return;

    try {
      final token = Supabase.instance.client.auth.currentSession!.accessToken;
      final response = await http.post(
        Uri.parse('${apiBaseUrl.replaceAll(RegExp(r'/+$'), '')}/api/v1/shops'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': result['name'],
          'slug': result['slug'],
          'default_language': result['language'],
          'enabled_languages': [result['language']],
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Shop creation failed (${response.statusCode}): ${response.body}');
      }
      await _loadShops();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shop created successfully.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My shops', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => Supabase.instance.client.auth.signOut(),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createShop,
        icon: const Icon(Icons.add),
        label: const Text('Add shop'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadShops,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Welcome back', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Your digital menu workspace', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            if (_loading) const Center(child: CircularProgressIndicator()),
            if (_error != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_error!, style: const TextStyle(color: Colors.orangeAccent)),
                ),
              ),
            if (!_loading && _error == null && _shops.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Icon(Icons.storefront_outlined, size: 44, color: Color(0xFF58A0FF)),
                      SizedBox(height: 12),
                      Text('Create your first shop', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('Your shop profile and primary menu will be created together.'),
                    ],
                  ),
                ),
              ),
            ..._shops.map((shop) => Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.storefront)),
                title: Text(shop['shop_name']?.toString() ?? 'Shop'),
                subtitle: Text('/m/${shop['slug'] ?? ''}'),
                trailing: const Icon(Icons.chevron_right),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class CreateShopDialog extends StatefulWidget {
  const CreateShopDialog({super.key});

  @override
  State<CreateShopDialog> createState() => _CreateShopDialogState();
}

class _CreateShopDialogState extends State<CreateShopDialog> {
  final _name = TextEditingController();
  final _slug = TextEditingController();
  String _language = 'en';

  @override
  void dispose() {
    _name.dispose();
    _slug.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create your shop'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Shop name'),
              onChanged: (value) {
                // Suggest a URL-safe slug; owners can still edit it before creation.
                _slug.text = value.toLowerCase().trim().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _slug,
              decoration: const InputDecoration(labelText: 'Public menu slug'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _language,
              decoration: const InputDecoration(labelText: 'Default language'),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'gu', child: Text('Gujarati')),
                DropdownMenuItem(value: 'hi', child: Text('Hindi')),
              ],
              onChanged: (value) => setState(() => _language = value ?? 'en'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final name = _name.text.trim();
            final slug = _slug.text.trim();
            if (name.isEmpty || !RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$').hasMatch(slug) || slug.length < 3) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enter a shop name and a valid slug (3+ characters).')),
              );
              return;
            }
            Navigator.pop(context, {'name': name, 'slug': slug, 'language': _language});
          },
          child: const Text('Create shop'),
        ),
      ],
    );
  }
}
