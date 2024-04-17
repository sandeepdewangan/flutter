# Bloc

[Flutter Bloc Tutorial For Beginners | BLoC Architecture/Pattern &amp; State Management Explained - YouTube](https://www.youtube.com/watch?v=SDk_GldOtK8)

## Table of Contents

* Cubit, BlocBuilder, BlocProvider

* Bloc Basic, Multibloc Provider

* Todo App - Cubit, BlocBuilder

* BlocConsumer, BlocListener, BlocBuilder

* Debugging Bloc State, BlocObserver

* Weather App - RepositoryProvider

## Cubit, BlocBuilder, BlocProvider

`counter_cubit.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() {
    emit(state + 1);
  }
}
```

`home_page.dart`

```dart
class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the instance of counterCubit
    final counterCubit = BlocProvider.of<CounterCubit>(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            //  only the text widget will be rebuilt whenever 
            // state changes.
            BlocBuilder<CounterCubit, int>(
              bloc: counterCubit,
              builder: (context, counter) {
                return Text(
                  '$counter',
                  style: const TextStyle(
                    fontSize: 50,
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const IncPage(),
                ),
              ),
              child: const Text("Go to Inc Page"),
            ),
.................
```

`inc_page.dart`

```dart
class IncPage extends StatelessWidget {
  const IncPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the instance of counterCubit
    final counterCubit = BlocProvider.of<CounterCubit>(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => counterCubit.increment(),
              child: const Text("Increment"),
            ),
          ],
```

`main.dart`

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // We can use BlocProvider to provide the instance of the bloc/cubit class to different pages.
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage(),
      ),
    );
  }
}
```

## Bloc Basic, Multibloc Provider

* sealed classes

* part of concepts

**Directory Structure**

.
└── lib/
 ├── bloc/
 │ ├── counter_bloc.dart
 │ └── counter_events.dart
 ├── home_page.dart
 └── main.dart

`counter_bloc.dart`

```dart
part 'counter_events.dart';

class CounterBloc extends Bloc<CounterEvents, int> {
  CounterBloc() : super(0) {
    on<CounterIncremented>((event, emit) {
      emit(state + 1);
    });
    on<CounterDecremented>((event, emit) {
      emit(state - 1);
    });
  }
}
```

`counter_events.dart`

```dart
part of 'counter_bloc.dart';

sealed class CounterEvents {}

class CounterIncremented extends CounterEvents {}

class CounterDecremented extends CounterEvents {}
```

`home_page.dart`

```dart
 Widget build(BuildContext context) {
    final counterBloc = BlocProvider.of<CounterBloc>(context);
    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<CounterBloc, int>(
            builder: (context, counter) {
              return Text('$counter');
            },
          ),
          ElevatedButton(
            onPressed: () => counterBloc.add(CounterIncremented()),
            child: const Text("Increment"),
          ),
          ElevatedButton(
            onPressed: () => counterBloc.add(CounterDecremented()),
            child: const Text("Decrement"),
          ),
        ],
      ),
    );
  }
```

`main_page.dart`

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CounterBloc()),
      ],
      child: MaterialApp(
        .............
        ),
        home: HomePage(),
      ),
    );
  }
}
```

## Todo App - Cubit, BlocBuilder

* ListView.builder

* context.read

`todo.dart`

```dart
class Todos {
  final String title;
  final DateTime createdAt;

  Todos({required this.title, required this.createdAt});
}
```

`todo_cubit.dart`

```dart
class TodoCubit extends Cubit<List<Todos>> {
  TodoCubit() : super([]);

  void addTodo(String title) {
    final todo = Todos(title: title, createdAt: DateTime.now());
    // state should always be modifiable through emit function only.
    emit([...state, todo]);
  }
}
```

`todo_add_page.dart`

```dart
Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Add todo",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<TodoCubit>().addTodo(titleController.text.trim());
                Navigator.pushNamed(context, '/');
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
```

`todo_list_page.dart`

```dart
Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TodoCubit, List<Todos>>(
          builder: (context, todos) {
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-todo'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

`main.dart`

```dart
Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit(),
      child: MaterialApp(
        theme: ThemeData(
          ...........
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const TodoListPage(),
          '/add-todo': (context) => TodoAddPage(),
        },
      ),
    );
  }
```

## BlocConsumer, BlocListener, BlocBuilder

BlocListener - used for functionality that needs to occur once per state change such as navigation, showing snackbar, dialogbox etc.

BlocBuilder - handle the UI in response to state change.

BlocConsumer - BlocListener + BlocBuilder.

`AuthBloc`

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
  }

  _onAuthLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    // show user waiting indicator
    emit(AuthLoading());
    // process the user details
    final String email = event.email;
    final String password = event.password;
    // validation logic
    if (password.length < 6) {
      return emit(AuthFailure('The password cannot be less tha 6 chars.'));
    }
    //other logic goes here...

    // call api and check for user authentication.
    // if everything is correct, redirect user to home page with user id.
    await Future.delayed(const Duration(seconds: 3));
    return emit(AuthSuccess(userid: email));
  }
}));
    });
  }
}
```

`AuthEvent`

```dart
sealed class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({
    required this.email,
    required this.password,
  });
}
```

`AuthState`

```dart
sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String userid;
  AuthSuccess({required this.userid});
}

class AuthFailure extends AuthState {
  final String errorMsg;
  AuthFailure(this.errorMsg);
}
```

`Login Page`

```dart
Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // all logic for showing user error and toast messages goes here.
          if (state is AuthFailure) {
            // display error msg to user
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMsg)));
          }
          if (state is AuthSuccess) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/home', (route) => false);
          }
        },
        builder: (context, state) {
          return state is AuthLoading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    TextField(),
                    ),
                    TextField(),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              AuthLoginRequested(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                      },
                      child: const Text("Login"),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
```

`Home Page`

```dart
Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state as AuthSuccess;
    return Scaffold(
      body: Center(
        child: Text(authState.userid),
      ),
    );
  }
```

## Debugging Bloc State, BlocObserver

Use provided method

* onChange

* onTransition - based on events and states.

* onError

We dont need to write each of these method in each bloc classes. Instead we can make a BlocObserver class.

```dart
class AppBlocObserver extends BlocObserver {
  // Whenever a new bloc created.
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print(bloc);
  }

  // onChange()
  // onTransition()
}
```

Register it to main class

```dart
void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}
```

## Weather App - RepositoryProvider

Bloc Architecture

```shell
.
└── lib/
    ├── bloc/
    │   ├── weather_bloc.dart
    │   ├── weather_event.dart
    │   └── weather_state.dart
    ├── data/
    │   ├── data_provider/
    │   │   └── weather_data_provider.dart
    │   └── repository/
    │       └── weather_repository.dart
    ├── model/
    │   └── weather_model.dart
    └── presentation/
        ├── pages
        └── widgets
```

`data_provider`: All code for CRUD operations. API call. Here we should not modify or process data. We should simply return the raw data obtained from API call.

`repository`:  It will call to data_provider class and do the necessary processing.

* Throw error from here that will catch by Bloc.



`weather_bloc.dart`

```dart
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<WeatherFetched>(_onWeatherFetched);
  }

  void _onWeatherFetched(
      WeatherFetched event, Emitter<WeatherState> emit) async {
    try {
      emit(WeatherLoading());
      final weather = await weatherRepository.getCurrentWeather();
      final weatherModel = WeatherModel(
        weather: weather['weather'][0]['main'],
        desc: weather['weather'][0]['description'],
      );
      emit(WeatherSuccess(weatherModel));
    } catch (e) {
      emit(WeatherFailure('$e from WeatherBloc'));
    }
  }
}
```

`weather_event.dart`

```dart
sealed class WeatherEvent {}

class WeatherFetched extends WeatherEvent {}
```

`weather_state.dart`

```dart
sealed class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherSuccess extends WeatherState {
  final WeatherModel weatherModel;
  WeatherSuccess(this.weatherModel);
}

class WeatherFailure extends WeatherState {
  final String errorMsg;
  WeatherFailure(this.errorMsg);
}

```

`weather_data_provider.dart`

```dart
class WeatherDataProvider {
  Future<Response> getCurrentCityWeather(String cityName) async {
    try {
      final res = await get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiSecret'));
      return res;
    } catch (e) {
      throw e.toString();
    }
  }
}
```

`weather_repository.dart`

```dart
class WeatherRepository {
  final WeatherDataProvider weatherDataProvider;
  WeatherRepository(this.weatherDataProvider);

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';
      final weatherData =
          await weatherDataProvider.getCurrentCityWeather(cityName);
      final data = jsonDecode(weatherData.body);
      if (weatherData.statusCode != 200) {
        throw 'An unexpected error occured';
      }
      return data;
    } catch (e) {
      throw '$e from WeatherRepository';
    }
  }
}
```

`weather_model.dart`

```dart
class WeatherModel {
  final String weather;
  final String desc;
  WeatherModel({required this.weather, required this.desc});
}
```

`main.dart`

```dart
Widget build(BuildContext context) {
    return RepositoryProvider(
      // one time WeatherDataProvided to all.
      create: (context) => WeatherRepository(
        WeatherDataProvider(),
      ),
      child: BlocProvider(
        // Here WeatherRepository instances are passed on.
        create: (context) => WeatherBloc(
          context.read<WeatherRepository>(),
        ),
        child: MaterialApp(
          ..............
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
```

`home_page.dart`

```dart
Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) 
                    return const CircularProgressIndicator();
          if (state is WeatherFailure) {
            return Text(state.errorMsg);
          }
          if (state is WeatherSuccess) {
            return Column(
              children: [
                Text(state.weatherModel.weather),
                Text(state.weatherModel.desc),
              ],
            );
          }
          return const Text("Something else");
        },
      ),
    );
  }
```
