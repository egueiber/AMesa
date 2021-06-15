import 'package:amesaadm/models/questionario.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/user_manager.dart';
import 'package:amesaadm/views/Base/base_screen.dart';
import 'package:amesaadm/views/Login/login_screen.dart';
import 'package:amesaadm/views/signup/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:amesaadm/models/product.dart';
import 'package:amesaadm/models/cart_manager.dart';
import 'package:amesaadm/models/product_manager.dart';
import 'package:amesaadm/models/questionariomanager.dart';
import 'package:amesaadm/views/Product/product_screen.dart';
import 'package:amesaadm/views/cart/cart_screen.dart';
import 'package:amesaadm/models/home_manager.dart';
import 'package:amesaadm/models/admin_users_manager.dart';
import 'package:amesaadm/views/edit_products/edit_product_screen.dart';
import 'package:amesaadm/views/questionario/edit/editquestionario.dart';
import 'package:amesaadm/views/select_product/select_product_screen.dart';
import 'package:amesaadm/views/questionario/questionarioscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserManager(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => ProductManager(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => QuestionarioManager(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => HomeManager(),
            lazy: false,
          ),
          ChangeNotifierProxyProvider<UserManager, CartManager>(
            create: (_) => CartManager(),
            lazy: false,
            update: (_, userManager, cartManager) =>
                cartManager..updateUser(userManager),
          ),
          ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
            create: (_) => AdminUsersManager(),
            lazy: false,
            update: (_, userManager, adminUsersManager) =>
                adminUsersManager..updateUser(userManager),
          )
        ],
        child: MaterialApp(
            title: 'Sistema t1',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: const Color.fromARGB(255, 4, 125, 141),
                scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
                appBarTheme: const AppBarTheme(elevation: 0),
//        primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity),
            initialRoute: '/base',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/signup':
                  return (MaterialPageRoute(builder: (_) => SignUpScreen()));
                case '/login':
                  return (MaterialPageRoute(builder: (_) => LoginScreen()));
                case '/select_product':
                  return MaterialPageRoute(
                      builder: (_) => SelectProductScreen());
                case '/base':
                  return (MaterialPageRoute(builder: (_) => BaseScreen()));
                case '/cart':
                  return MaterialPageRoute(builder: (_) => CartScreen());
                case '/edit_products':
                  return MaterialPageRoute(
                      builder: (_) =>
                          EditProductScreen(settings.arguments as Product));
                case '/edit_questionarios':
                  return MaterialPageRoute(
                      builder: (_) => EditQuestionarioScreen(
                          settings.arguments as Questionario));
                case '/product':
                  return MaterialPageRoute(
                      builder: (_) =>
                          ProductScreen(settings.arguments as Product));
                //ProductScreen(settings.arguments as Product));
                case '/questionario':
                  return MaterialPageRoute(
                      builder: (_) => QuestionarioScreen(
                          settings.arguments as Questionario));
                default:
                  return (MaterialPageRoute(builder: (_) => BaseScreen()));
              }
            }));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
