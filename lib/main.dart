import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc_observer.dart';
import 'features/product/domain/entities/product.dart';
import 'features/product/presentation/bloc/product_bloc.dart';
import 'features/product/presentation/pages/add_update_page.dart';
import 'features/product/presentation/pages/detail_page.dart';
import 'features/product/presentation/pages/home_page.dart';
import 'features/product/presentation/pages/search_page.dart';
import 'injection_cointainer.dart' as dp_i;
import 'injection_cointainer.dart';

void main() async {
  // Finish all Binding and other setted up correctly
  WidgetsFlutterBinding.ensureInitialized();
  // and intialize all our event handler
  await dp_i.init();
  // Cordinator for our events
  Bloc.observer = ProductBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ),

      /**
       * Create Material App and aftre that we pass On GenerateRoute and pass
       * according to setting value we navigate between the screen the screen we
       * 
       * / ---> HomePage
       */
      child: MaterialApp(
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return _createRoute(const HomePage());
            case '/search':
              return _createRoute(const SearchPage());
            case '/add':
              return _createRoute(const AddUpdatePage(
                isAdding: true,
              ));
            case '/update':
              final args = settings.arguments as Product;
              return _createRoute(AddUpdatePage(
                isAdding: false,
                product: args,
              ));
            case '/details':
              final args = settings.arguments as Product;
              return _createRoute(DetailPage(
                product: args,
              ));
            default:
              return null;
          }
        },
        theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(),
            primaryColor: Colors.blueAccent,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent)),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

PageRouteBuilder _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
