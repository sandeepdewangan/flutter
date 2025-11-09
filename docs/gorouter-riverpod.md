## Go Router with Riverpod
Three screens with three bottom navigation bar. Additional there is signin, signup and error page. 
Features:

✅	Navigation between pages using GoRouter.

✅	Route protection.

✅	Navigation Shell, bottom navigation bar implementation.

✅	Shared preferences implementation for saving the auth state.


`main.dart`
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routeProvider);
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
```
`auth_state_provider.dart`
```dart
@riverpod
class AuthState extends _$AuthState {
  @override
  bool build() {
    return ref.read(sharedPreferencesProvider).getBool('auth') ?? false;
  }

  Future<void> setAuthState(bool value) async {
    await ref.read(sharedPreferencesProvider).setBool('auth', value);
    state = value;
  }
}
```
`shared_pref_provider.dart`
```dart
@riverpod
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError();
}
```
`router_provider.dart`
```dart
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter route(Ref ref) {
  // Get the auth state, authenticated or not.
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/first',
    redirect: (context, state) {
      //! Route protection
      final authenticated = authState;
      final tryingSignin = state.matchedLocation == '/signin';
      final tryingSignup = state.matchedLocation == '/signup';
      final authenticating = tryingSignin || tryingSignup;

      if (!authenticated) return authenticating ? null : '/signin';
      if (authenticating) return '/first';
      return null;
    },
    routes: [
      GoRoute(
        path: '/signin',
        name: RouteNames.signin,
        builder: (context, state) {
          return const SignInPage();
        },
      ),
      GoRoute(
        path: '/signup',
        name: RouteNames.signup,
        builder: (context, state) {
          return const SignUpPage();
        },
      ),

      // Statefull shell route is used for bottom navigation bar.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScafoldWithNavPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/first',
                name: RouteNames.first,
                builder: (context, state) {
                  return const FirstPage();
                },
                routes: [
                  GoRoute(
                    path: '/detail',
                    name: RouteNames.firstDetail,
                    builder: (context, state) {
                      return const FirstDetailsPage();
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/second',
                name: RouteNames.second,
                builder: (context, state) {
                  return const SecondPage();
                },
                routes: [
                  // By default the detail page will be opened above the bottom navigation bar.
                  // To open by hiding bottom navigation bar use, parentNavigatorKey.
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: '/detail/:id',
                    name: RouteNames.secondDetail,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return SecondDetailsPage(id: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/third',
                name: RouteNames.third,
                builder: (context, state) {
                  return const ThirdPage();
                },
                routes: [
                  GoRoute(
                    path: '/detail/:id',
                    name: RouteNames.thirdDetail,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      final firstName =
                          state.uri.queryParameters['firstName'] ?? "Anonymous";
                      final lastName =
                          state.uri.queryParameters['lastName'] ?? "Anonymous";
                      return ThirdDetailsPage(
                        id: id,
                        firstname: firstName,
                        lastname: lastName,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        NotFoundPage(message: state.error.toString()),
  );
}
```

`scaffold_withnavbar_page.dart`
```dart
class ScafoldWithNavPage extends StatelessWidget {
  const ScafoldWithNavPage({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.first_page), label: "First"),
          BottomNavigationBarItem(icon: Icon(Icons.pages), label: "Second"),
          BottomNavigationBarItem(icon: Icon(Icons.last_page), label: "Third"),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
```
`first_page.dart`
```dart
class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("First")),
      body: Center(
        child: Column(
          children: [
            Text("First Page"),
            OutlinedButton(
              onPressed: () {
                GoRouter.of(context).pushNamed(RouteNames.firstDetail);
              },
              child: Text("First Details Page"),
            ),
          ],
        ),
      ),
    );
  }
}
```
`second_page.dart`
```dart
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Second")),
      body: Center(
        child: Column(
          children: [
            Text("Second Page"),
            OutlinedButton(
              onPressed: () {
                GoRouter.of(context).pushNamed(
                  RouteNames.secondDetail,
                  pathParameters: {'id': '1'},
                );
              },
              child: Text("Second Details Page"),
            ),
          ],
        ),
      ),
    );
  }
}
```
`third_page.dart`
```dart
class ThirdPage extends ConsumerWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Third Page")),
      body: Center(
        child: Column(
          children: [
            Text("Third Page"),
            OutlinedButton(
              onPressed: () {
                GoRouter.of(context).pushNamed(
                  RouteNames.thirdDetail,
                  pathParameters: {'id': '2'},
                  queryParameters: {'firstName': 'Sandeep'},
                );
              },
              child: Text("Third details page"),
            ),
            OutlinedButton(
              onPressed: () {
                context.goNamed(RouteNames.signin);
              },
              child: Text("Sign in"),
            ),
            OutlinedButton(
              onPressed: () async {
                await ref.read(authStateProvider.notifier).setAuthState(false);
              },
              child: Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
```
`signin_page.dart`
```dart
class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign in Page")),
      body: Center(
        child: Column(
          children: [
            Text("Sign in"),
            OutlinedButton(
              onPressed: () async{
                await ref.read(authStateProvider.notifier).setAuthState(true);
              },
              child: Text("Sign-in"),
            ),
            OutlinedButton(
              onPressed: () {
                context.goNamed(RouteNames.signup);
              },
              child: Text("Not a member, signup!"),
            ),
            OutlinedButton(
              onPressed: () {
                context.goNamed(RouteNames.first);
              },
              child: Text("Goto first page!"),
            ),
          ],
        ),
      ),
    );
  }
}
```
`signup_page.dart`
```dart
class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign up Page")),
      body: Center(
        child: Column(
          children: [
            Text("Sign up"),
            OutlinedButton(
              onPressed: () async {
                await ref.read(authStateProvider.notifier).setAuthState(true);
              },
              child: Text("Sign-up"),
            ),
            OutlinedButton(
              onPressed: () {
                context.goNamed(RouteNames.signin);
              },
              child: Text("Already a member, signin!"),
            ),
            OutlinedButton(
              onPressed: () {
                context.goNamed(RouteNames.second);
              },
              child: Text("Goto second page!"),
            ),
            OutlinedButton(
              onPressed: () {
                context.go('/nowhere');
              },
              child: Text("Goto No where! page"),
            ),
          ],
        ),
      ),
    );
  }
}
```

