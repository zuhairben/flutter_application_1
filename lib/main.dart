import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:block/bloc/ProductBloc.dart';
import 'package:block/ProductList.dart';
import 'package:block/bloc/ProductEvent.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (context) => ProductBloc()..add(FetchProducts()),
          child: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Products",
          style: TextStyle(
            color: Colors.white,
          ),
        )),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: ProductList(),
      ),
    );
  }
}
