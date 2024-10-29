import 'package:flora/models/floraModel.dart';
import 'package:flora/providers/floraProvider.dart';
import 'package:flora/widgets/drawer.dart';
import 'package:flora/screens/flora/floraItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Favfloras extends ConsumerStatefulWidget {
  const Favfloras({super.key});

  @override
  ConsumerState<Favfloras> createState() => _FavFlorasState();
}

class _FavFlorasState extends ConsumerState<Favfloras> {
  @override
  Widget build(BuildContext context) {
    final floraData = ref.watch(floraProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Favorite Floras'),
        ),
        drawer: const FloraDrawer(),
        body: StreamBuilder(
            stream: floraData.allFavoriteFloras,
            builder: (ctx, floraSnapshot) {
              if (floraSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              print(floraSnapshot);

              if (!floraSnapshot.hasData || floraSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Favorite Flora not found'),
                );
              }

              if (floraSnapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }

              final loadedFloras = floraSnapshot.data!.docs;
              return ListView.builder(
                  itemCount: loadedFloras.length,
                  itemBuilder: (ctx, index) => FloraItem(
                      floraData: Flora(loadedFloras[index].data()['favorite'],
                          id: '${loadedFloras[index].id}',
                          title: loadedFloras[index].data()['floraName'],
                          desc: loadedFloras[index].data()['description'],
                          image: loadedFloras[index].data()['image_url'],
                          amount: loadedFloras[index].data()['amount'],
                          place: loadedFloras[index].data()['place'])));
            }));
  }
}
