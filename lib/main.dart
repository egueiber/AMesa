import 'package:amesaadm/models/aluno.dart';
import 'package:amesaadm/models/turma.dart';
import 'package:amesaadm/models/topico.dart';
import 'package:amesaadm/models/tipoaprendizagem.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:amesaadm/models/alunosmanager.dart';
import 'package:amesaadm/models/topicosmanager.dart';
import 'package:amesaadm/models/tipoaprendizagemmanager.dart';
import 'package:amesaadm/models/turmasalunos.dart';
import 'package:amesaadm/views/aluno/alunoscreen.dart';
import 'package:amesaadm/views/aluno/edit/editaluno.dart';
import 'package:amesaadm/models/turmasmanager.dart';
import 'package:amesaadm/views/questionario/componentes/questionarioatribuiscreen.dart';
import 'package:amesaadm/views/questionarioexec/questaoexec.dart';
import 'package:amesaadm/views/questionarioexec/questionarioexecmain.dart';
import 'package:amesaadm/views/turma/turmascreen.dart';
import 'package:amesaadm/views/turma/edit/editturma.dart';
import 'package:amesaadm/views/topico/topicoscreen.dart';
import 'package:amesaadm/views/tipoaprendizagem/tipoaprendizagemscreen.dart';
import 'package:amesaadm/views/topico/edit/edittopico.dart';
import 'package:amesaadm/views/tipoaprendizagem/edit/edittipoaprendizagem.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/user_manager.dart';
import 'package:amesaadm/views/Base/base_screen.dart';
import 'package:amesaadm/views/Login/login_screen.dart';
import 'package:amesaadm/views/signup/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:amesaadm/models/questionarioturmamanager.dart';
import 'package:amesaadm/models/questionariomanager.dart';
import 'package:amesaadm/models/home_manager.dart';
import 'package:amesaadm/models/admin_users_manager.dart';
import 'package:amesaadm/views/questionario/edit/editquestionario.dart';
//import 'package:amesaadm/views/select_product/select_product_screen.dart';
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
            create: (_) => QuestionarioManager(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => HomeManager(),
            lazy: false,
          ),
          ChangeNotifierProxyProvider<UserManager, QuestionarioTurmaManager>(
            create: (_) => QuestionarioTurmaManager(),
            lazy: false,
            update: (
              _,
              userManager,
              cartManager,
            ) =>
                cartManager..updateUser(userManager),
          ),
          ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
            create: (_) => AdminUsersManager(),
            lazy: false,
            update: (_, userManager, adminUsersManager) =>
                adminUsersManager..updateUser(userManager),
          ),
          ChangeNotifierProvider(
            create: (_) => AlunoManager(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => TurmaManager(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => TurmasAlunos(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => TopicosManager(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => TipoAprendizagemManager(),
            lazy: false,
          ),
        ],
        child: MaterialApp(
            title: 'A Mesa ',
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
                case '/base':
                  return (MaterialPageRoute(builder: (_) => BaseScreen()));

                case '/edit_turma':
                  return MaterialPageRoute(
                      builder: (_) =>
                          EditTurmaScreen(settings.arguments as Turma));
                case '/edit_topico':
                  return MaterialPageRoute(
                      builder: (_) =>
                          EditTopicoScreen(settings.arguments as Topico));
                case '/edit_tipoaprendizagem':
                  return MaterialPageRoute(
                      builder: (_) => EditTipoAprendizagemScreen(
                          settings.arguments as TipoAprendizagem));
                case '/edit_aluno':
                  return MaterialPageRoute(
                      builder: (_) =>
                          EditAlunoScreen(settings.arguments as Aluno));
                case '/edit_questionarios':
                  return MaterialPageRoute(
                      builder: (_) => EditQuestionarioScreen(
                          settings.arguments as Questionario));
                case '/atribui_questionarios':
                  return MaterialPageRoute(
                      builder: (_) => QuestionarioAtribuiScreen(
                          settings.arguments as Questionario));

                case '/turma':
                  return MaterialPageRoute(
                      builder: (_) => TurmaScreen(settings.arguments as Turma));
                case '/topico':
                  return MaterialPageRoute(
                      builder: (_) =>
                          TopicoScreen(settings.arguments as Topico));
                case '/tipoaprendizagem':
                  return MaterialPageRoute(
                      builder: (_) => TipoAprendizagemScreen(
                          settings.arguments as TipoAprendizagem));
                case '/aluno':
                  return MaterialPageRoute(
                      builder: (_) => AlunoScreen(settings.arguments as Aluno));
                case '/questionario':
                  return MaterialPageRoute(
                      builder: (_) => QuestionarioScreen(
                          settings.arguments as Questionario));
                case '/questionarioexec':
                  return MaterialPageRoute(
                      builder: (_) => QuestionarioScreenExecMain(
                          settings.arguments as Questionario));
                case '/questaoformexec':
                  return MaterialPageRoute(
                      builder: (_) =>
                          QuestaoFormExec(settings.arguments as Questionario));
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
              'Naõ pressione o botão tantas vezes',
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
