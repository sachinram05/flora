import 'package:flora/models/floraModel.dart';
import 'package:flora/providers/floraProvider.dart';
import 'package:flora/screens/flora/addFlora.dart';
import 'package:flora/widgets/drawer.dart';
import 'package:flora/screens/flora/floraItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final floraData = ref.watch(floraProvider);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_channel_rounded,
                size: 42,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              Text(
                'Flora',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddFlora()));
                },
                icon: Icon(
                  Icons.add,
                  size: 34,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ))
          ],
        ),
        drawer: const FloraDrawer(),
        body: StreamBuilder(
            stream: floraData.allFloras,
            builder: (ctx, floraSnapshot) {
              if (floraSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              print(floraSnapshot.data);

              if (!floraSnapshot.hasData || floraSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Flora not found'),
                );
              }

              if (floraSnapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }

              final loadedFloras = floraSnapshot.data!.docs;

              return Column(children: [
                Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: CupertinoSearchTextField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          fontSize: 16),
                      // controller: _searchController,
                    )),
                const SizedBox(height: 2),
                Expanded(
                  child: ListView.builder(
                      itemCount: loadedFloras.length,
                      itemBuilder: (ctx, index) => FloraItem(
                          floraData: Flora(
                              loadedFloras[index]
                                  .data()['favorite'], //true/false
                              id: '${loadedFloras[index].id}',
                              title: loadedFloras[index].data()['floraName'],
                              desc: loadedFloras[index].data()['description'],
                              image: loadedFloras[index].data()['image_url'],
                              amount: loadedFloras[index].data()['amount'],
                              place: loadedFloras[index].data()['place']))),
                )
              ]);
            }));
  }
}
