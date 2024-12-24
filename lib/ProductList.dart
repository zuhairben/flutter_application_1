import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:block/bloc/ProductBloc.dart';
import 'package:block/bloc/ProductState.dart';
import 'package:http/http.dart' as http;

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
      if (state is ProductLoading) {
        return const CircularProgressIndicator();
      } else if (state is ProductLoaded) {
        return ListView.builder(itemBuilder: (context, index) {
          return Card(
              elevation: 4,
              key: ValueKey(index),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(state.products[index].thumbnail),
                    ),
                    title: Text(state.products[index].title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.products[index].description,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          state.products[index].price.toString(),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
              ));
        });
      } else if (state is ProductError) {
        return Center(child: Text(state.error));
      }
      return const Center(child: Text("Press button to fetch products"));
    });
  }
}
