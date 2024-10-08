import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0), // Add left padding
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            child: Image.asset(
              'assets/images/clean_architecture.jpg',
              height: 80,
              fit: BoxFit
                  .cover, // Ensures the image covers the area without distortion
            ),
          ),
        ),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                'Aug 19, 2024',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black45,
                    fontSize: 13),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Row(
              children: [
                Text(
                  'Hello, ',
                  style: TextStyle(color: Colors.black45, fontSize: 15),
                ),
                Text(
                  'Nuredin',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                )
              ],
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5),
              ),
              width: 50,
              height: 50,
              child: InkWell(
                onTap: () {},
                splashColor: Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      const Icon(Icons.notifications_none_rounded),
                      Positioned(
                        top: 3,
                        right: 5,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 63, 81, 243),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 15, top: 30, bottom: 20),
        child: buildHome(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add');
        },
        backgroundColor: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 20.0,
        ),
      ),
    );
  }

  Widget buildHome(BuildContext context) {
    // Trigger loading of products
    context.read<ProductBloc>().add(GetAllProductEvent());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Available Products',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/search');
                },
                splashColor: Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is LoadAllProductState) {
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProductBloc>().add(GetAllProductEvent());
                  },
                  child: ListView.separated(
                    itemCount: state.products.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCard(
                        product: Product(
                          id: state.products[index].id,
                          imageUrl: state.products[index].imageUrl,
                          name: state.products[index].name,
                          price: state.products[index].price,
                          description: state.products[index].description,
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (state is ProductErrorState) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            } else {
              return Text('No products available');
            }
          },
        ),
      ],
    );
  }
}
